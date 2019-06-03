# frozen_string_literal: true

module Messaging
  module API
    # Comment
    module Debug
      include Constants

      def hello(node = :undefined)
        thy_will_be_done!(DEBUG, HELLO, node)
      end

      def ping!(callback)
        so?(WOLFGANG, PING, {}, callback)
      end

      # Publish
      def announce(service)
        thy_will_be_done(service, ANNOUNCE, :wolfgang)
      end
    end
  end
end
