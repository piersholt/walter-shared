# frozen_string_literal: true

module Yabber
  module API
    # API::Manager
    module Manager
      include Constants

      def devices!(callback)
        messaging_request(DEVICE, DEVICES, {}, callback)
      end

      def connect(device_address)
        messaging_action(DEVICE, CONNECT, address: device_address)
      end

      def disconnect(device_address)
        messaging_action(DEVICE, DISCONNECT, address: device_address)
      end
    end
  end
end
