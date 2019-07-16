# frozen_string_literal: true

require_relative 'controller/player'
require_relative 'controller/target'

module Yabber
  module API
    # API::Controller
    module Controller
      include Target
      include Player

      # @note not technically within the scope of a controller
      # Action
      def volume_up!
        messaging_action(WOLFGANG, VOLUME_UP)
      end

      # @note not technically within the scope of a controller
      # Action
      def volume_down!
        messaging_action(WOLFGANG, VOLUME_DOWN)
      end
    end
  end
end
