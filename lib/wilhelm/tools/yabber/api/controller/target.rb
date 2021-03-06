# frozen_string_literal: true

module Yabber
  module API
    module Controller
      # API::Controller::Target
      module Target
        include Constants

        # Request
        def targets!(callback)
          messaging_request(TARGET, TARGET, {}, callback)
        end

        # Request
        def player!(player_path, callback)
          messaging_request(
            TARGET, PLAYER,
            { path: player_path },
            callback
          )
        end
      end
    end
  end
end
