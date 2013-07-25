require 'json'
require_relative 'day'

class Database
  def initialize(path)
    @path = path
  end

  def today
    day(0)
  end

  def day(day_counter = 0)
    day_hash = data[key(day_counter)]
    hash_to_day(day_hash)
  end

  def days(range)
    entries = data
    result = []
    entries.each_pair do |date, day_hash|
      if range.include?(date.to_i)
        result << {"date" => date.to_i, "day" => hash_to_day(day_hash)}
      end
    end
    result
  end

  def save_today(day)
    current_data = data
    current_data[today_key] = day.to_hash
    save(current_data)
  end

  private
  def data
    File.open(@path, 'a+') do |file|
      file.size > 0 ? JSON.load(file) : {}
    end
  end

  def save(hash)
    File.open(@path, 'w+') { |f| f.write(hash.to_json) }
  end

  def today_key
    key(0)
  end

  def key(day_counter = 0)
    (Date.today + day_counter).to_time.to_i.to_s
  end

  def hash_to_day(day_hash)
    Day.new(intervals: day_hash["intervals"], tasks: day_hash["tasks"]) if day_hash
  end
end