# frozen_string_literal: true

module Yabber
  # Yabber::Publisher
  class Publisher < MessagingQueue
    extend Forwardable
    include ManageableThreads
    include ThreadSafe
    include Announce
    extend Announce

    PROG = 'Publisher'

    DEFAULTS = {
      role: :PUB,
      protocol: 'tcp',
      address: '*',
      port: '5556'
    }.freeze

    def self.params(port: PORT_WOLFGANG_PUB_SUB, host: ADDRESS_PI)
      instance.address = host
      instance.port = port
    end

    def self.disconnect
      instance.worker.raise(GoHomeNow, 'Disconnect called!')
    end

    def self.destroy
      instance.destroy
    end

    def self.queue_message(message)
      instance.queue_message(message)
    end

    private

    # @override
    def logger
      LogActually.publisher
    end

    # @pverride
    def open_socket
      logger.debug(PROG) { "Open Socket." }
      logger.debug(PROG) { "Socket: #{Thread.current}" }
      logger.debug(PROG) { "Role: #{role}" }
      logger.debug(PROG) { "URI: #{uri}" }
      context
      worker
      context.bind(role, uri)
    end

    def disconnect
      logger.debug(PROG) { '#disconnect' }
      result = socket.disconnect(uri)
      logger.debug(PROG) { "socket.disconnect => #{result}" }
      result
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

    def topic(message)
      message.topic
    end

    def payload(message)
      message.to_yaml
    end
  end
end
