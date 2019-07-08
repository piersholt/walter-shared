# frozen_string_literal: true

class LogActually
  # LogActually Constants
  module Constants
    RESET      = '0'
    LIGHT_GRAY = '37'
    GREEN      = '32'
    YELLOW     = '33'
    RED        = '31'
    MAGENTA    = '35'

    DEFAULT_LEVEL = Logger::INFO

    LEVEL_DEBUG = 'DEBUG'
    LEVEL_INFO = 'INFO'
    LEVEL_WARN = 'WARN'
    LEVEL_ERROR = 'ERROR'
    LEVEL_FATAL = 'FATAL'
    LEVEL_UNKNOWN = 'UNKNOWN'
    LEVEL_ANY = 'ANY'

    SEVERITY_TO_COLOUR_MAP = {
      LEVEL_DEBUG => :gray,
      LEVEL_INFO => :green,
      LEVEL_WARN => :yellow,
      LEVEL_ERROR => :red,
      LEVEL_FATAL => :red,
      LEVEL_UNKNOWN => :magenta,
      LEVEL_ANY => :magenta
    }.freeze

    MOI = 'LogActually'
  end
end
