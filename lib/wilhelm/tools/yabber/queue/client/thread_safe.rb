# frozen_string_literal: true

module Yabber
  class MessagingQueue
    module Client
      module ThreadSafe
        include MessagingQueue::ThreadSafe

        PROG = 'Client::ThreadSafe'

        # @override ZMQ.select due to what I think is odd IO.select behaviour
        def select(read = [], write = [], error = [], timeout = nil)
          poller = ZMQ::Poller.new
          read&.each { |s| poller.register_readable(s) }
          write&.each { |s| poller.register_writable(s) }
          ready = poller.poll(timeout)
          logger.debug(PROG) { "ready => #{ready}" }
          logger.debug(PROG) { "ready ? true : false => #{ready ? true : false}" }
          case ready
          when 1
            [poller.readables, poller.writables, []] if ready
          when 0
            false
          end
        end

        # @override ThreadSafe#queue_message
        def queue_message(request, callback)
          logger.debug(PROG) { 'Queue Message' }
          logger.debug(PROG) { "Queued Message: #{request}" }
          queue.push(request: request, callback: callback)
          true
        rescue StandardError => e
          with_backtrace(logger, e)
          false
        end

        def deserialize(serialized_object)
          logger.debug(PROG) { "#deserialize(#{serialized_object})" }
          command = Yabber::Serialized.new(serialized_object).parse
          logger.debug(PROG) { "Deserialized: #{command}" }
          logger.debug(PROG) { "name: #{command.name} (#{command.name.class})" }
          command
        end

        # @override ThreadSafe#pop
        def pop(i, thread_queue)
          logger.debug(PROG) { "Worker waiting (Next: Message ID: #{i})" }
          popped_request = thread_queue.pop

          req = popped_request[:request]
          popped_request[:request] = req.to_yaml

          logger.debug(PROG) { "Message ID: #{i} => #{popped_request}" }
          popped_request
        rescue MessagingQueue::Errors::GoHomeNow => e
          raise e
        rescue StandardError => e
          with_backtrace(logger, e)
        end

        # @override ThreadSafe#worker_process
        def worker_process(thread_queue)
          logger.debug(PROG) { "#worker_process (#{Thread.current})" }
          i = 1
          loop do
            string_hash = pop(i, thread_queue)
            # logger.debug(PROG) { "string_hash => #{string_hash}" }
            forward_to_zeromq(string_hash[:request], &string_hash[:callback])
            i += 1
            # Kernel.sleep(3)
          end
        rescue MessagingQueue::Errors::GoHomeNow => e
          logger.debug(PROG) { "#{e.class}: #{e.message}" }
          result = disconnect
          logger.debug(PROG) { "#disconnect => #{result}" }
          # with_backtrace(logger, e)
          # logger.fatal(PROG) { 'Okay byyyeeeee!' }
        end

        # @override ThreadSafe#forward_to_zeromq
        def forward_to_zeromq(string, &callback)
          timeout = 10
          logger.debug(PROG) { "#forward_to_zeromq(#{string})" }
          3.times do |i|
            result = socket.send(string)
            logger.debug(PROG) { "send(#{string}) => #{result}" }
            raise StandardError, 'message failed to send...' unless result
            logger.debug(PROG) { "#select([socket], nil, nil, #{timeout})" }
            if select([socket], nil, nil, timeout)
              serialized_reply = socket.recv
              logger.debug(PROG) { "serialized_reply => #{serialized_reply}" }
              reply = deserialize(serialized_reply)
              logger.debug(PROG) { "reply => #{reply}" }
              yield(reply, nil)
              return true
            else
              yield(reply, :timeout)
              logger.warn(PROG) { 'Timeout! Retry!' }
              close
              socket
              timeout *= 2
            end
            logger.warn(PROG) { 'Down?' }
          end

          yield(nil, :down)
        end
      end
    end
  end
end
