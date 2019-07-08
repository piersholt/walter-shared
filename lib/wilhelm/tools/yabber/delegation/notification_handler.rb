# frozen_string_literal: true

module Yabber
  # NotificationsRelay
  module NotificationsRelay
    def relay(notification)
      Publisher.send!(notification)
    end
  end
end
