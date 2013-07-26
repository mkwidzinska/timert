require 'date'

class DateFormatter
  
  def self.parse_hour(timestamp)
    timestamp ? Time.at(timestamp).to_s.split[1] : ""
  end

  def self.parse_date(timestamp)
    timestamp ? Time.at(timestamp).to_s.split[0] : ""
  end

  def self.parse_relative_date(day_counter = 0, today = Time.new)
    today_date = Date.new(today.year, today.month, today.day)
    parse_date((today_date + day_counter).to_time.to_i)    
  end

  def self.parse_elapsed_time(duration)
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