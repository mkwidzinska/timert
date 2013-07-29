require 'json'
require_relative 'day'

class Database
  # DatabaseFile as arg, interface: load, save, init(path)
  def initialize(path)
    @path = path
    # @json = file.load
  end

  def today
    day(0)
  end

  def day(day_counter = 0)    
    hash_to_day(data[key(day_counter)])
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
    # zamienic na save
    current_data = data
    current_data[today_key] = day.to_hash
    save(current_data)
  end

  private
  # load data
  def data
    File.open(@path, 'a+') do |file|
      file.size > 0 ? JSON.load(file) : {}
    end
  end
  # save data
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
    if day_hash
      Day.new(intervals: day_hash["intervals"], tasks: day_hash["tasks"])
    else
      Day.new
    end
  end
end