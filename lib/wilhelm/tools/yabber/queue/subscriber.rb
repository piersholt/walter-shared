# frozen_string_literal: true

module Yabber
  # Yabber::Subscriber
  class Subscriber < MessagingQueue
    extend Forwardable

    def_delegators :socket, :recv, :subscribe

    DEFAULTS = {
      role: :SUB,
      protocol: 'tcp',
      address: 'localhost',
      port: '5556'
    }.freeze

    def self.params(port: PORT_WOLFGANG_PUB_SUB, host: ADDRESS_PI)
      instance.address = host
      instance.port = port
      subscribe(ALL_TOPICS)
    end

    def self.receive_message
      topic = instance.socket.recv
      message = instance.socket.recv
      # puts "#{message}\n"
      message
    rescue ZMQ::Socket => e
      LogActually.messaging.error(self) { e }
      e.backtrace.each { |l| LogActually.messaging.error(l) }
    end

    def self.subscribe(topic = :broadcast)
      topic_string = topic.to_s
      topic_human = topic_string.empty? ? 'All Topics' : topic_string
      LogActually.messaging.debug(self) { "Subscribe: #{topic_human}" }
      instance.subscribe(topic_string)
    end

    # @override
    def setup(topic = :broadcast)
      super()
      topic = sanitize(topic)
      subscribe(topic)
    end

    private

    # @override
    def logger
      LogActually.subscriber
    end

    # @override
    def open_socket
      LogActually.messaging.info(self.class) { 'Open Socket.' }
      LogActually.messaging.debug(self.class) { "Socket: #{Thread.current}" }
      LogActually.messaging.debug(self.class) { "Role: #{role}" }
      LogActually.messaging.debug(self.class) { "URI: #{uri}" }
      context.connect(role, uri)
    rescue SystemCallError
      logger.error(self.class) { "Error when connecting to endpoint: #{uri}" }
      logger.error(self.class) { "Can #{address} be resolved to an address?" }
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
