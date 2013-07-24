require 'json'
require 'date'
require_relative 'day'

class Timer	
	attr_reader :path

	def initialize(path)
		@path = path
		File.open(@path, 'a+') do |file|
			@db = file.size > 0 ? JSON.load(file) : {}									
		end
	end

	def start
		if !on?
			time = today.add_start(time_now)		
			save
			time		
		end
	end

	def stop
		if on?
			time = today.add_stop(time_now)
			save
			time
		end
	end

	def add_task(task)
		today.add_task(task)
		save
	end

	def report(day_counter = 0)
		day = day(day_counter)
		{
			"total_elapsed_time" => day.total_elapsed_time,
			"tasks" => day.tasks,
			"intervals" => day.intervals
		}		
	end

	private	
	def save
		@db[key] = today.to_hash
		File.open(@path, 'w+') { |f| f.write(@db.to_json) }		
	end

	def today
		@today ||= day(0)
	end

	def time_now
		Time.now.to_i
	end

	def day(day_counter = 0)
		day_data = @db[key(day_counter)] || {}
		Day.new(intervals: day_data["intervals"],
			tasks: day_data["tasks"],
			on: day_data["on"])
		
	end

	def key(day_counter = 0)
		(Date.today + day_counter).to_time.to_i.to_s
	end

	def on?
		today.is_interval_started?
	end	
end