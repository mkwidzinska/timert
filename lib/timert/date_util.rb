require 'date'

module Timert
  class DateUtil
    
    def self.format_hour(timestamp)
      timestamp ? Time.at(timestamp).strftime("%H:%M:%S") : ""
    end

    def self.format_date(date)
      date ? date.strftime("%Y-%m-%d") : ""
    end

    def self.parse_time(arg)
      if arg
        hours, minutes = arg.split(":")
        now = Time.now
        Time.new(now.year, now.month, now.day, hours, minutes).to_i
      end
    end
  end
end