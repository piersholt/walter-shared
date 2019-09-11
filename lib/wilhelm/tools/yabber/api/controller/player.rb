# frozen_string_literal: true

module Yabber
  module API
    module Controller
      # API::Controller::Player
      module Player
        include Constants

        def play!(player_path)
          messaging_action(PLAYER, PLAY, path: player_path)
        end

        def pause!(player_path)
          messaging_action(PLAYER, PAUSE, path: player_path)
        end

        def stop!(player_path)
          messaging_action(PLAYER, STOP, path: player_path)
        end

        def next!(player_path)
          messaging_action(PLAYER, SEEK_NEXT, path: player_path)
        end

        def previous!(player_path)
          messaging_action(PLAYER, SEEK_PREVIOUS, path: player_path)
        end

        def scan_forward_start!(player_path)
          messaging_action(PLAYER, SCAN_FORWARD_START, path: player_path)
        end

        def scan_forward_stop!(player_path)
          messaging_action(PLAYER, SCAN_FORWARD_STOP, path: player_path)
        end

        def scan_backward_start!(player_path)
          messaging_action(PLAYER, SCAN_BACKWARD_START, path: player_path)
        end

        def scan_backward_stop!(player_path)
          messaging_action(PLAYER, SCAN_BACKWARD_STOP, path: player_path)
        end
      end
    end
  end
end
