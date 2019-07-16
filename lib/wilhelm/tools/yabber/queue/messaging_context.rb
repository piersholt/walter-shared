# frozen_string_literal: true

require 'rbczmq'

module Yabber
  # Yabber::MessagingContext
  class MessagingContext
    include Singleton
    # attr_accessor :counter

    def self.context
      instance.context
    end

    def self.semaphore
      instance.semaphore
    end

    def semaphore
      @semaphore ||= Mutex.new
    end

    def context
      semaphore.synchronize do
        @context ||= create_context
      end
    end

    def create_context
      LogActually.messaging.debug(self.class) { 'Create Context.' }
      LogActually.messaging.debug(self.class) { "Context: #{Thread.current}" }
      ZMQ::Context.new
    end
  end
end
