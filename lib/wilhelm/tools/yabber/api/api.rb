# frozen_string_literal: true

module Yabber
  # Yabber::API
  module API
    include LogActually::ErrorOutput
    include Constants
    include Debug
    include Manager
    include Controller

    # Publisher Action
    def messaging_action(command_topic, command_name, properties = {})
      action = Yabber::Action.new(node: Publisher.node, topic: command_topic, name: command_name, properties: properties)
      message_publish(action)
    end

    # Publisher Notification
    def messaging_notification(command_topic, command_name, properties = {})
      action = Yabber::Notification.new(node: Publisher.node, topic: command_topic, name: command_name, properties: properties)
      message_publish(action)
    end

    # Client Request
    def messaging_request(command_topic, command_name, properties = {}, callback)
      action = Yabber::Request.new(topic: command_topic, name: command_name, properties: properties)
      message_request(action, callback)
    end

    private

    # Publisher
    def message_publish(action)
      LogActually.messaging.debug(self.class) { "Publishing: #{action}"}
      Publisher.queue_message(action)
    rescue StandardError => e
      with_backtrace(LogActually.messaging, e)
    end

    # Client
    def message_request(action, callback)
      LogActually.messaging.debug(self.class) { "Requesting: #{action}"}
      Client.queue_message(action, callback)
    end

    alias thy_will_be_done! messaging_action
    alias just_lettin_ya_know! messaging_notification
    alias so? messaging_request
    alias fuckin_send_it_lads! message_publish
    alias request_this message_request
  end
end
