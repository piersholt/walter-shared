# frozen_string_literal: true

module Yabber
  # Yabber::Server
  class Server < MessagingQueue
    extend Forwardable
    # include ThreadSafe

    def_delegators :socket, :recv, :send
    # attr_reader :thread

    DEFAULTS = {
      role: :REP,
      protocol: 'tcp',
      address: '*',
      port: '5557'
    }.freeze

    def self.recv
      instance.recv
    rescue ZMQ::Socket => e
      LogActually.messaging.error(self) { "#{e}" }
      e.backtrace.each { |l| LogActually.messaging.error(l) }
    end

    def self.params(port: PORT_WOLFGANG_CLIENT_SERVER, host: ADDRESS_LOCALHOST)
      instance.address = host
      instance.port = port
    end

    private

    # @override
    def logger
      LogActually.server
    end

    # @pverride
    def open_socket
      LogActually.messaging.debug(self.class) { "Open Socket." }
      LogActually.messaging.debug(self.class) { "Socket: #{Thread.current}" }
      LogActually.messaging.debug(self.class) { "Role: #{role}" }
      LogActually.messaging.debug(self.class) { "URI: #{uri}" }
      # context
      # worker
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
