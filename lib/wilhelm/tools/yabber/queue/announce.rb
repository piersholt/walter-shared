# frozen_string_literal: false

module Yabber
  class MessagingQueue
    # MessagingQueue::Announce
    # Only used by Publisher
    module Announce
      include Yabber::Constants
      include ManageableThreads

      PROG = 'Announce'.freeze

      def announcement(ident)
        @announce = Thread.new(ident) do |ident|
          begin
            3.times do
              announce(ident)
              Kernel.sleep(1)
            end
          rescue StandardError => e
            with_backtrace(logger, e)
          end
          logger.debug(PROG) { "Annoucement complete!" }
        end
        add_thread(@announce)
        true
      end

      def announce(ident)
        logger.debug(PROG) { "#announce(#{ident})" }
        notification = Yabber::Notification.new(
          topic: CONTROL,
          name: :announcement
        )
        logger.debug(PROG) { "Announce: #{notification}" }
        logger.debug(PROG) { "Publisher Announce Send." }
        queue_message(notification)
      end
    end
  end
end
