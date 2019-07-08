# frozen_string_literal: true

module Yabber
  # Yabber::Action
  # Action is a Publisher message class for messages that should result
  # in an action via their respective handlers.
  class Action < BaseMessage
    attr_accessor :name, :properties

    def initialize(topic:, name: nil, node: :undefined, properties: {})
      super(type: ACTION, topic: topic, node: node)
      @name = name if name
      @properties = properties if properties
    end

    def hashified
      { action: { name: name, properties: properties } }
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
