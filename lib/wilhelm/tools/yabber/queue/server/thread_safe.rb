# frozen_string_literal: true

module Yabber
  class MessagingQueue
    module Server
      # Server::ThreadSafe
      module ThreadSafe
        include MessagingQueue::ThreadSafe

        LOG_QUEUE_REPLY = 'Queue Reply'
        LOG_QUEUED_REPLY = 'Queued Reply: '

        def queue_reply(reply)
          logger.debug(LOG_QUEUE) { LOG_QUEUE_REPLY }
          logger.debug(LOG_QUEUE) { "#{LOG_QUEUED_REPLY}#{reply}" }
          queue.push(reply)
          true
        rescue StandardError => e
          with_backtrace(logger, e)
          false
        end

        # @override ThreadSafe#pop
        def pop(i, thread_queue)
          logger.debug(PROG) { "Worker waiting (Next: Message ID: #{i})" }
          popped_reply = thread_queue.pop
          reply = popped_reply.to_yaml
          logger.debug(PROG) { "Message ID: #{i} => #{reply}" }
          reply
        rescue GoHomeNow => e
          raise e
        rescue StandardError => e
          with_backtrace(logger, e)
        end

        # @override ThreadSafe#worker_process
        def worker_process(thread_queue)
          logger.debug(PROG) { "#worker_process (#{Thread.current})" }
          i = 1
          loop do
            reply_yaml = pop(i, thread_queue)
            forward_to_zeromq(reply_yaml)
            i += 1
          end
        rescue GoHomeNow => e
          logger.debug(PROG) { "#{e.class}: #{e.message}" }
          result = disconnect
          logger.debug(PROG) { "#disconnect => #{result}" }
        end

        def forward_to_zeromq(reply)
          logger.debug(self.class) { "Worker: #{Thread.current}" }
          result = socket.send(reply)
          raise StandardError, LOG_FAILED_SEND unless result
        end
      end
    end
  end
end
