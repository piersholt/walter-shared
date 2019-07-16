# frozen_string_literal: true

module Yabber
  class MessagingQueue
    # Yabber::MessagingQueue::Defaults
    module Defaults
      ADDRESS_PI = 'pi.local'
      ADDRESS_MBP = 'pmbp.local'
      ADDRESS_LOCALHOST = 'localhost'

      PORT_WALTER_PUB_SUB = '5556'
      PORT_WALTER_CLIENT_SERVER = '5557'

      PORT_WOLFGANG_PUB_SUB = '5558'
      PORT_WOLFGANG_CLIENT_SERVER = '5559'
    end
  end
end
