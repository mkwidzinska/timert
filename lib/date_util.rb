require 'date'

class DateUtil
  
  def self.format_hour(timestamp)
    timestamp ? Time.at(timestamp).strftime("%H:%M:%S") : ""
  end

  def self.parse_date(date)
    date ? date.strftime("%Y-%m-%d") : ""
  end

  def self.format_elapsed_time(duration)
    "#{hours(duration)}h #{minutes(duration)}min #{seconds(duration)}sec"
  end

  def self.round_duration(duration)
    hours = hours(duration)
    part = (minutes(duration) / 60.0) * 10
    second_half = Range.new(5, 10)

    if second_half.include?(part)
      hours += 1
      part = 0
    elsif part > 0
      part = 5
    end
    part.zero? ? hours.to_s : "#{hours}.#{part}"
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