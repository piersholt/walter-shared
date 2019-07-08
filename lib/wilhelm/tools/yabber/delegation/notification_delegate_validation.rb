# frozen_string_literal: false

module Yabber
  # All mehods that are expected to be overriden by NotificationDelegate
  module NotificationDelegateValidation
    include DelegateValidation

    def take_responsibility(___ = nil)
      raise(NaughtyHandler, self.class.name)
    end
  end
end
