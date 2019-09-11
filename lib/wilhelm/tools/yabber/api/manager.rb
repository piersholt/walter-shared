# frozen_string_literal: true

module Yabber
  module API
    # API::Manager
    module Manager
      include Constants

      # Request
      def devices!(callback)
        messaging_request(DEVICE, DEVICES, {}, callback)
      end

      # Request
      def device!(device_path, callback)
        messaging_request(
          DEVICE, DEVICE,
          { path: device_path },
          callback
        )
      end

      # Action
      def connect!(device_path)
        messaging_action(DEVICE, CONNECT, path: device_path)
      end

      # Action
      def disconnect!(device_path)
        messaging_action(DEVICE, DISCONNECT, path: device_path)
      end

      alias connect connect!
      alias disconnect disconnect!
    end
  end
end
