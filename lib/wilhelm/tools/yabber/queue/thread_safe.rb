# frozen_string_literal: true

module Yabber
  class MessagingQueue
    # MessagingQueue::ThreadSafe
    # A ZeroMQ context cannot be used across threads so all outgoing messages
    # are routed via a Ruby's threadsafe Queue class. Ruby's Mutex is also
    # used to prevent a race condition when initially spawning the worker.
    module ThreadSafe
      include ManageableThreads

      PROG = 'ThreadSafe'

      QUEUE_SIZE = 32
      SESSION_FORMAT = '%j_%H_%M'
      LOG_CREATE_QUEUE = '#create_queue'
      LOG_CREATE_WORKER = '#create_worker'
      LOG_WORKER_STARTING = 'TreadSafe Worker starting...'
      LOG_WORKER_ENDING = 'TreadSafe Worker ended...!'
      LOG_QUEUE = 'ThreadSafe#queue_message'
      LOG_QUEUE_MESSAGE = 'Queue Message'
      LOG_QUEUED_MESSAGE = 'Queued Message: '
      THREAD_SAFE_WORKER = 'ThreadSafe Worker'
      LOG_FAILED_SEND = 'Failed send?'
      LOG_CHAIN_NOT_HANDLED = 'Chain did not handle!'

      def self.semaphore
        instance.semaphore
      end

      def semaphore
        @semaphore ||= Mutex.new
      end

      def queue
        semaphore.synchronize do
          @queue ||= create_queue
        end
      end

      def worker
        semaphore.synchronize do
          @worker ||= create_worker
        end
      end

      def create_queue
        logger.debug(PROG) { "#{LOG_CREATE_QUEUE}: [Thread: #{Thread.current}}" }
        new_queue = SizedQueue.new(QUEUE_SIZE)
        create_worker(new_queue)
        new_queue
      rescue StandardError => e
        with_backtrace(logger, e)
      end

      def create_worker(worker_queue = nil)
        logger.debug(PROG) { "#{LOG_CREATE_WORKER}: [Thread: #{Thread.current}}" }
        new_worker = create_worker_thread(worker_queue || queue)
        add_thread(new_worker)
        new_worker
      end

      def create_worker_thread(worker_queue)
        logger.debug(PROG) { "#create_worker_thread #{Thread.current}" }
        Thread.new(worker_queue) do |thread_safe_queue|
          begin
            Thread.current[:name] = THREAD_SAFE_WORKER
            logger.debug(PROG) { LOG_WORKER_STARTING }
            worker_loop(thread_safe_queue)
            logger.debug(PROG) { LOG_WORKER_ENDING }
          rescue StandardError => e
            logger.error(PROG) { e }
            e.backtrace.each do |line|
              logger.error(PROG) { line }
            end
          end
        end
      end
    end
  end
end
