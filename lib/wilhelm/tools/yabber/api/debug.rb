# frozen_string_literal: true

module Yabber
  module API
    # API::Debug
    module Debug
      include Constants

      # Request
      def ping!(callback)
        messaging_request(WOLFGANG, PING, {}, callback)
      end

      # Publish
      def announce(service)
        messaging_notification(service, ANNOUNCE)
      end
    end
  end
end
