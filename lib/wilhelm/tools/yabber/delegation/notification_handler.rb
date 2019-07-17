# frozen_string_literal: true

module Yabber
  # NotificationsRelay
  module NotificationsRelay
    def relay(notification)
      Publisher.queue_message(notification)
    end
  end
end
