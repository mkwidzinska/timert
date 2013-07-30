require 'json'
require_relative 'day'

module Timert
  class Database
    
    def initialize(file)
      @file = file
    end

    def today
      day
    end

    def day(date = Date.today)    
      hash_to_day(load_data[key(date)], date)
    end

    def days(range)
      entries = load_data
      result = []
      entries.each_pair do |date, day_hash|
        day = hash_to_day(day_hash, Time.at(date.to_i).to_date)
        if range.include?(day.date)
          result << day
        end
      end 
      result
    end

    def save(day)
      current_data = load_data
      current_data[key(day.date)] = day.to_hash
      save_data(current_data)
    end

    private
    
    def load_data
      @file.load
    end

    def save_data(hash)
      @file.save(hash)
    end

    def key(date = nil)
      date ? date.to_time.to_i.to_s : key(Date.today)
    end

    def hash_to_day(day_hash, date)
      if day_hash
        Day.new(
          intervals: day_hash["intervals"], 
          tasks: day_hash["tasks"],
          date: date)
      else
        Day.new
      end
    end
  end
end