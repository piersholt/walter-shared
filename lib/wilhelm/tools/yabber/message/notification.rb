# frozen_string_literal: true

module Yabber
  # Yabber::Notification
  # Notification is a Publisher message class for messages that have no
  # expected outcome.
  class Notification < BaseMessage
    attr_accessor :name, :properties

    def initialize(topic:, name: nil, node: :undefined, properties: {})
      super(type: NOTIFICATION, topic: topic, node: node)
      @name = name if name
      @properties = properties if properties
    end

    def hashified
      { notification: { name: name, properties: properties } }
    end

    def to_h
      base = super
      me = hashified
      base.merge(me)
    end

    def to_s
      "#{self.class}: Topic: #{topic}, Name: #{name}, Properties: #{properties}"
    end
  end
end
