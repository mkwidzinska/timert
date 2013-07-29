require 'date'

class DateUtil
  
  def self.format_hour(timestamp)
    timestamp ? Time.at(timestamp).strftime("%H:%M:%S") : ""
  end

  def self.format_date(date)
    date ? date.strftime("%Y-%m-%d") : ""
  end

  def self.format_elapsed_time(duration)
    "#{hours(duration)}h #{minutes(duration)}min #{seconds(duration)}sec"
  end

  def self.round_duration(duration)
    ((duration / 1800.0).ceil / 2.0).to_s
  end

  def self.parse_time(arg)
    if arg
      hours, minutes = arg.split(":")
      now = Time.now
      Time.new(now.year, now.month, now.day, hours, minutes).to_i
    end
  end

  private
  def self.hours(duration)
    duration / 3600
  end

  def self.minutes(duration)
    (duration % 3600) / 60
  end

  def self.seconds(duration)
    duration % 60
  end
end