# frozen_string_literal: true

module Yabber
  class MessagingQueue
    # MessagingQueue::ThreadSafe
    # A ZeroMQ context cannot be used across threads so all outgoing messages
    # are routed via a Ruby's threadsafe Queue class. Ruby's Mutex is also
    # used to prevent a race condition when initially spawning the worker.
    module ThreadSafe
      include ManageableThreads

      QUEUE_SIZE = 32
      SESSION_FORMAT = '%j_%H_%M'
      LOG_CREATE_QUEUE = 'Create Queue'
      LOG_CREATE_WORKER = 'Create Worker'
      LOG_WORKER_STARTING = 'Worker starting...'
      LOG_WORKER_ENDING = 'Worker ended...!'
      LOG_QUEUE = 'ThreadSafe#queue_message'
      LOG_QUEUE_MESSAGE = 'Queue Message'
      LOG_QUEUED_MESSAGE = 'Queued Message: '
      LOG_PUBLISHER_WORKER = 'Publisher Worker'
      LOG_FAILED_SEND = 'Failed send?'
      LOG_CHAIN_NOT_HANDLED = 'Chain did not handle!'

      def self.semaphore
        instance.semaphore
      end

      def semaphore
        @semaphore ||= Mutex.new
      end

      def queue_message(message)
        logger.debug(LOG_QUEUE) { LOG_QUEUE_MESSAGE }
        logger.debug(LOG_QUEUE) { "#{LOG_QUEUED_MESSAGE}#{message}" }
        queue.push(message)
        true
      rescue StandardError => e
        with_backtrace(logger, e)
        false
      end

      def queue
        Mutex.new.synchronize do
          logger.debug(self.class) { "#queue [Thread: #{Thread.current}]" }
          @queue ||= create_queue
        end
      end

      def worker
        semaphore.synchronize do
          @worker ||= create_worker
        end
      end

      def fuck_off?
        @fuck_off ||= false
      end

      def fuck_off!
        @fuck_off = true
      end

      def worker_process(thread_queue)
        logger.debug(self.class) { "#worker_process (#{Thread.current})" }
        i = 1
        loop do
          message_hash = pop(i, thread_queue)
          forward_to_zeromq(message_hash[:topic], message_hash[:payload])
          i += 1
        end
      rescue MessagingQueue::Errors::GoHomeNow => e
        logger.debug(self.class) { "#{e.class}: #{e.message}" }
        result = disconnect
        logger.debug(self.class) { "#disconnect => #{result}" }
      end

      def create_queue
        logger.debug(self.class) { LOG_CREATE_QUEUE }
        new_queue = SizedQueue.new(QUEUE_SIZE)
        create_worker(new_queue)
        new_queue
      rescue StandardError => e
        with_backtrace(logger, e)
      end

      def create_worker(existing_queue = nil)
        return false if fuck_off?
        logger.debug(self.class) { LOG_CREATE_WORKER }
        q = existing_queue ? existing_queue : queue
        @worker = create_worker_thread(q)
        add_thread(@worker)
        fuck_off!
      end

      def create_worker_thread(q)
        Thread.new(q) do |thread_queue|
          logger.debug(self.class) { "Worker: #{Thread.current}" }
          Thread.current[:name] = LOG_PUBLISHER_WORKER
          begin
            logger.debug(self.class) { LOG_WORKER_STARTING }
            worker_process(thread_queue)
            logger.debug(self.class) { LOG_WORKER_ENDING }
          rescue StandardError => e
            logger.error(self.class) { e }
            e.backtrace.each do |line|
              logger.error(self.class) { line }
            end
          end
        end
      end

      def pop(i, thread_queue)
        logger.debug(self.class) { "Worker waiting (Next: Message ID: #{i})" }
        popped_messsage = thread_queue.pop
        popped_messsage.id = i
        popped_messsage.session = Time.now.strftime(SESSION_FORMAT)
        message_hash = { topic: topic(popped_messsage),
                         payload: payload(popped_messsage) }

        logger.debug(self.class) { "Message ID: #{i} => #{message_hash}" }
        message_hash
      rescue IfYouWantSomethingDone
        logger.warn(self.class) { LOG_CHAIN_NOT_HANDLED }
      rescue MessagingQueue::Errors::GoHomeNow => e
        raise e
      rescue StandardError => e
        with_backtrace(logger, e)
      end

      def forward_to_zeromq(topic, payload)
        logger.debug(self.class) { "Worker: #{Thread.current}" }
        topic = sanitize(topic)
        payload = sanitize(payload)

        result_topic = sendm(topic)
        result_payload = send(payload)
        logger.debug(topic)
        logger.debug(payload)
        raise StandardError, LOG_FAILED_SEND unless result_topic && result_payload
      end
    end
  end
end
