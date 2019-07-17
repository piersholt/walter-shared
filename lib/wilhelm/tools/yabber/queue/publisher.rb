# frozen_string_literal: true

require_relative 'publisher/thread_safe'

module Yabber
  # Yabber::Publisher
  class Publisher < MessagingQueue
    extend Forwardable
    include Yabber::MessagingQueue::Publisher::ThreadSafe
    include Announce

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

    def self.queue_message(message)
      instance.queue_message(message)
    end

    def self.announce(ident)
      instance.announce(ident)
    end

    def self.announcement(ident)
      instance.announcement(ident)
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
      queue
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
  end
end
