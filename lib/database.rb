require 'json'
require_relative 'day'

class Database 
	def initialize(path)
		@path = path
	end

	def day(day_counter = 0) 
		data = open
		day_hash = data[key(day_counter)]
		Day.new(intervals: day_hash["intervals"], tasks: day_hash["tasks"])
	end
	
	def save_day(day, day_counter = 0)
		data = open
		data[key(day_counter)] = day.to_hash
		save(data)
	end

	private
	def open
		File.open(@path, 'a+') do |file|
			file.size > 0 ? JSON.load(file) : {}									
		end
	end

	def save(hash)
		File.open(@path, 'w+') { |f| f.write(hash.to_json) }		
	end

	def key(day_counter = 0)
		(Date.today + day_counter).to_time.to_i.to_s
	end
end