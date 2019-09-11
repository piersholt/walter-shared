# frozen_string_literal: true

module Yabber
  # NotificationDelegate
  module NotificationDelegate
    include NotificationDelegateValidation
    attr_accessor :successor

    def notification_delegate
      self.class.name
    end

    def handle(notification)
      if responsible?(notification)
        logger.debug(notification_delegate) { "I am responsible for #{notification.name}!" }
        take_responsibility(notification)
      else
        logger.debug(notification_delegate) { "Not me! Forwarding: #{notification.name}" }
        forward(notification)
      end
    end

    def logger
      LogActually.notifications
      raise(StandardError, 'do not use NotificationDelegate logger as is shared...')
    end

    def forward(notification)
      raise(IfYouWantSomethingDone, "No one to handle: #{notification}") unless successor
      successor.handle(notification)
    end

    def responsible?(notification)
      result = notification.topic == responsibility
      logger.debug(notification_delegate) { "#{notification.topic} == #{responsibility} => #{result}" }
      result
    end

    def not_handled(command)
      # logger.info(notification_delegate) { "#{command.name}: Currently not implemented." }
      logger.warn(notification_delegate) { "#{command.name}: Currently not implemented. (#{command.properties})" }
    end
  end
end
