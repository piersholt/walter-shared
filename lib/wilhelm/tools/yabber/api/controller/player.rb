# frozen_string_literal: true

module Yabber
  module API
    module Controller
      # API::Controller::Player
      module Player
        include Constants

        def play!
          messaging_action(PLAYER, PLAY)
        end

        def pause!
          messaging_action(PLAYER, PAUSE)
        end

        def stop!
          messaging_action(PLAYER, STOP)
        end

        def next!
          messaging_action(PLAYER, SEEK_NEXT)
        end

        def previous!
          messaging_action(PLAYER, SEEK_PREVIOUS)
        end

        def scan_forward_start!
          messaging_action(PLAYER, SCAN_FORWARD_START)
        end

        def scan_forward_stop!
          messaging_action(PLAYER, SCAN_FORWARD_STOP)
        end

        def scan_backward_start!
          messaging_action(PLAYER, SCAN_BACKWARD_START)
        end

        def scan_backward_stop!
          messaging_action(PLAYER, SCAN_BACKWARD_STOP)
        end
      end
    end
  end
end
