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
      end
    end
  end
end
