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
			turn_on
			time = add_start_time
			save
			time		
		end
	end

	def stop
		if on?
			turn_off
			time = add_stop_time
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
			"total_elapsed_time" => total_elapsed_time(day),
			"tasks" => day["tasks"],
			"intervals" => day["intervals"]
		}		
	end

	private	
	def total_elapsed_time(day)
		total = 0
		if day && day["intervals"]
			day["intervals"].each { |i| total += interval_duration(i) }
		end		
		total
	end

	def interval_duration(interval)
		diff = interval["stop"].to_i - interval["start"].to_i
		diff > 0 ? diff : 0
	end

	def add_start_time
		today.add_start(time_now)		
	end

	def add_stop_time
		today.add_stop(time_now)
	end

	def save
		@db[key] = today.to_hash
		File.open(@path, 'w+') { |f| f.write(@db.to_json) }		
	end

	def today
		if !@today			
			@db[key] ||= {}
			@today = Day.new(@db[key])
		end
		@today
	end

	def time_now
		Time.now.to_i
	end

	def day(day_counter = 0)
		@db[key(day_counter)] || {}
	end

	def key(day_counter = 0)
		(Date.today + day_counter).to_time.to_i.to_s
	end

	def on?
		today.on
	end

	def turn_on
		today.on = true
	end

	def turn_off
		today.on = false
	end
end