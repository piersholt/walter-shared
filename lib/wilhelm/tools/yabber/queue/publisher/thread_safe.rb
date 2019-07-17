# frozen_string_literal: true

module Yabber
  class MessagingQueue
    module Publisher
      # Publisher::ThreadSafe
      module ThreadSafe
        include MessagingQueue::ThreadSafe

        PROG = 'Publisher::ThreadSafe'

        def queue_message(message)
          logger.debug(PROG) { LOG_QUEUE_MESSAGE }
          queue.push(message)
          logger.debug(PROG) { "#{LOG_QUEUED_MESSAGE}#{message}" }
          true
        rescue StandardError => e
          with_backtrace(logger, e)
          false
        end

        def worker_loop(thread_queue)
          i = 1
          loop do
            message_hash = pop(i, thread_queue)
            forward_to_zeromq(message_hash[:topic], message_hash[:payload])
            i += 1
          end
        rescue MessagingQueue::Errors::GoHomeNow => e
          logger.debug(PROG) { "#{e.class}: #{e.message}" }
          result = disconnect
          logger.debug(PROG) { "#disconnect => #{result}" }
        end

        def pop(i, thread_queue)
          logger.debug(PROG) { "Worker waiting (Next: Message ID: #{i})" }
          popped_messsage = thread_queue.pop

          popped_messsage.id = i
          popped_messsage.session = Time.now.strftime(SESSION_FORMAT)
          message_hash = {
            topic: topic(popped_messsage),
            payload: payload(popped_messsage)
          }

          logger.debug(PROG) { "Message ID: #{i} => #{message_hash}" }
          message_hash
        rescue MessagingQueue::Errors::GoHomeNow => e
          raise e
        rescue StandardError => e
          with_backtrace(logger, e)
        end

        def forward_to_zeromq(topic, payload)
          logger.debug(PROG) { "Worker: #{Thread.current}" }
          topic = sanitize(topic)
          payload = sanitize(payload)

          result_topic = socket.sendm(topic)
          result_payload = socket.send(payload)
          logger.debug(topic)
          logger.debug(payload)
          raise StandardError, LOG_FAILED_SEND unless result_topic && result_payload
        end

        def topic(message)
          message.topic
        end

        def payload(message)
          message.to_yaml
        end
      end
    end
  end
end
