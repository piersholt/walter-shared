# frozen_string_literal: true

module Yabber
  # MessagingQueue
  class MessagingQueue
    include Defaults
    include Constants
    include Singleton
    include LogActually::ErrorOutput
    include Errors

    attr_writer :role, :protocol, :address, :port
    # attr_accessor :counter

    def destroy
      logger.debug(self.class) { '#destroy' }
      result = context.destroy
      logger.debug(self.class) { "context.destroy => #{result}" }
      result
    end

    def logger
      LogActually.messaging
    end

    def close
      LogActually.messaging.warn(self.class) { '#close' }
      result = socket.close
      LogActually.messaging.warn(self.class) { "socket.close => #{result}" }
      @socket = nil
    end

    # def self.disconnect
    #   instance.disconnect
    # end

    def self.print_configuration
      instance.print_configuration
    end

    def print_configuration
      logger.debug(self.class.name) { "Role: #{role}: #{uri}" }
    end

    def sanitize(string)
      string.to_s
    end

    def self.setup
      instance.setup
      instance
    end

    def self.node
      instance.node
    end

    def node
      @node ||= :undefined
    end

    def public_socket
      socket
    end

    private

    def context
      @context ||= create_context
    end

    def create_context
      MessagingContext.context
    end

    def socket?
      @socket ? true : false
    end

    def socket
      @socket ||= open_socket
    end

    def role
      @role ||= default_role
    end

    def protocol
      @protocol ||= default_protocol
    end

    def address
      @address ||= default_address
    end

    def port
      @port ||= default_port
    end

    def uri(t_protocol = protocol, t_address = address, t_port = port)
      "#{t_protocol}://#{t_address}:#{t_port}"
    end
  end
end
