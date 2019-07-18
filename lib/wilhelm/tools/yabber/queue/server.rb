# frozen_string_literal: true

require_relative 'server/thread_safe'

module Yabber
  # Yabber::Server
  class Server < MessagingQueue
    extend Forwardable
    # include Yabber::MessagingQueue::Server::ThreadSafe

    def_delegators :socket, :recv, :send

    PROG = 'Server'
    DEFAULTS = {
      role: :REP,
      protocol: 'tcp',
      address: '*',
      port: '5557'
    }.freeze
    
    def self.params(port: PORT_WOLFGANG_CLIENT_SERVER, host: ADDRESS_LOCALHOST)
      instance.address = host
      instance.port = port
    end

    def self.receive_message
      instance.receive_message
    end

    def self.send_message(message)
      instance.send_message(message)
    end

    def receive_message
      socket.recv
    end

    def send_message(message)
      socket.send(message)
    end

    private

    # @override
    def logger
      LogActually.server
    end

    # @pverride
    def open_socket
      logger.debug(PROG) { "Open Socket." }
      logger.debug(PROG) { "Socket: #{Thread.current}" }
      logger.debug(PROG) { "Role: #{role}" }
      logger.debug(PROG) { "URI: #{uri}" }
      context.bind(role, uri)
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

    def payload(message)
      message.to_yaml
    end
  end
end
