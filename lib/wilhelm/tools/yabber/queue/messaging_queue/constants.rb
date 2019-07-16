# frozen_string_literal: true

module Yabber
  # Yabber::MessagingQueue::Errors
  class MessagingQueue
    module Errors
      class GoHomeNow < StandardError
      end
    end
  end

  class MessagingQueue
    # Yabber::MessagingQueue::Constants
    module Constants
      ALL_TOPICS = ''
    end
  end
end
