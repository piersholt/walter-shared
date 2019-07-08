# frozen_string_literal: false

class LogActually
  # LogActually::Formatter Formatter for Ruby's Logger
  module Formatter
    include ASCIIColour

    FORMAT_SEVERITY = '%-5s'.freeze
    FORMAT_PROGNAME = '%20s'.freeze
    FORMAT_LOGGER_ID = '%12s'.freeze
    FORMAT_TIME = '%H:%M:%S'.freeze

    def format_severity(severity)
      format(FORMAT_SEVERITY, severity)
    end

    def format_progname(progname)
      format(FORMAT_PROGNAME, progname)
    end

    def format_logger_id
      format(FORMAT_LOGGER_ID, id)
    end

    def format_time(time)
      time.strftime(FORMAT_TIME)
    end

    def default_formatter
      proc do |severity, time, progname, msg|
        color = severity_colour(severity)

        formatted_severity = format_severity(severity)
        formatted_time = format_time(time)
        formatted_progname = format_progname(progname)
        formatted_logger_id = format_logger_id

        msg.strip! rescue StandardError

        m = "#{gray}#{formatted_time}#{clear} "\
            "[#{color}#{formatted_severity}#{clear}] "\
            "[#{formatted_logger_id}#{clear}] "\
            "[#{formatted_progname}#{clear}] "\
            "#{msg}#{clear}"
        m.concat("\n") unless severity == Logger::UNKNOWN
      end
    end
  end
end
