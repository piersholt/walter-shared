# frozen_string_literal: false

module Yabber
  class MessagingQueue
    # MessagingQueue::Announce
    # Only used by Publisher
    module Announce
      include Yabber::Constants
      include ManageableThreads

      PROG = 'Announce'.freeze

      def announcement(announcer)
        @node = announcer
        @announce = Thread.new(announcer) do |announcer|
          begin
            3.times do
              announce(announcer)
              Kernel.sleep(1)
            end
          rescue StandardError => e
            with_backtrace(logger, e)
          end
          logger.debug(PROG) { "Annoucement complete!" }
        end
        add_thread(@announce)
      end

      def announce(announcer)
        logger.debug(PROG) { "#announce(#{announcer})" }
        notification = Yabber::Notification.new(
          node: announcer,
          topic: CONTROL,
          name: :announcement
        )
        logger.debug(PROG) { "Announce: #{notification}" }
        logger.debug(PROG) { "Publisher Announce Send." }
        Publisher.queue_message(notification)
      end

      def self.announce
        instance.announce(announcer)
      end

      def self.announement
        instance.announement(announcer)
      end
    end
  end
end
