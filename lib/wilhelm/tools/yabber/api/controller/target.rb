# frozen_string_literal: true

module Yabber
  module API
    module Controller
      # API::Controller::Target
      module Target
        include Constants

        # Request
        def player!(callback)
          messaging_request(TARGET, PLAYER, {}, callback)
        end

        # Action
        def volume_up!
          messaging_action(TARGET, VOLUME_UP)
        end

        # Action
        def volume_down!
          messaging_action(TARGET, VOLUME_DOWN)
        end
      end
    end
  end
end
