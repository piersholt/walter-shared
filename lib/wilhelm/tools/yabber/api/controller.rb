# frozen_string_literal: true

require_relative 'controller/player'
require_relative 'controller/target'

module Yabber
  module API
    # API::Controller
    module Controller
      include Target
      include Player
    end
  end
end
