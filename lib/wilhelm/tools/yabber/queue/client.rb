# frozen_string_literal: true

require_relative 'client/thread_safe'

module Yabber
  # Yabber::Client
  class Client < MessagingQueue
    extend Forwardable
    include Yabber::MessagingQueue::Client::ThreadSafe

    PROG = 'Client'
    DEFAULTS = {
      role: :REQ,
      protocol: 'tcp',
      address: 'localhost',
      port: '5557'
    }.freeze

    def self.params(port: PORT_WOLFGANG_PUB_SUB, host: ADDRESS_PI)
      instance.address = host
      instance.port = port
    end

    def self.disconnect
      instance.worker.raise(GoHomeNow, 'Disconnect called!')
    end

    def self.queue_message(message)
      instance.queue_message(message)
    end

    private

    # @override
    def logger
      LogActually.client
    end

    # @pverride MessagingQueue#open_socket
    def open_socket
      logger.debug(PROG) { 'Open Socket.' }
      logger.debug(PROG) { "Socket: #{Thread.current}" }
      logger.debug(PROG) { "Role: #{role}" }
      logger.debug(PROG) { "URI: #{uri}" }
      context
      queue
      connect
    end

    def connect
      logger.debug(PROG) { '#connect' }
      result = context.connect(role, uri)
      logger.debug(PROG) { "socket.connect => #{result}" }
      result
    rescue SystemCallError
      logger.error(PROG) { "Error when connecting to endpoint: #{uri}" }
      logger.error(PROG) { "Can #{address} be resolved to an address?" }
      raise('Yabber error!')
    end

    def default_role
      DEFAULTS[:role]
    end

    def default_protocol
      DEFAULTS[:protocol]
    end

    def default_address
      DEFAULTS[:address]
    end

    def default_port
      DEFAULTS[:port]
    end
  end
end
