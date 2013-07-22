require 'json'
require 'date'

class Timer	
	attr_reader :path

	def initialize(path)
		@path = path
		File.open(@path, 'a+') { |file|
			@db = file.size > 0 ? JSON.load(file) : {}									
		}
	end

	def start
		if !is_on?
			turn_on
			time = add_start_time
			save
			time		
		end
	end

	def stop
		if is_on?
			turn_off
			time = add_stop_time
			save
			time
		end
	end

	def add_task(task)
		today["tasks"] ||= []
		today["tasks"].push(task)
		save
	end

	def report(day_counter = 0)
		{
			"total_elapsed_time" => total_elapsed_time(day_counter),
			"tasks" => tasks(day_counter),
			"intervals" => intervals(day_counter)
		}		
	end

	private	
	def is_on?
		on == true
	end

	def total_elapsed_time(day_counter = 0)
		day = day(day_counter)
		total = 0
		if day && day["intervals"]
			day["intervals"].each do |interval|
				diff = interval["stop"].to_i - interval["start"].to_i
				total += diff if diff > 0
			end		
		end		
		total
	end

	def tasks(day_counter = 0)		
		day = day(day_counter)
		if day && day["tasks"]
			day["tasks"]
		end
	end

	def intervals(day_counter = 0)
		day = day(day_counter)
		day["intervals"] if day
	end

	def add_start_time
		time = time_now
		today["intervals"] ||= []
		today["intervals"].push({"start" => time})
		time
	end

	def add_stop_time
		time = time_now
		today["intervals"].last["stop"] = time
		time		
	end

	def save
		File.open(@path, 'w+') { |f| f.write(@db.to_json) }		
	end

	def today
		if !@today			
			@db[today_key] ||= {}
			@today = @db[today_key]
		end
		@today
	end

	def today_key
		Date.today.to_time.to_i.to_s
	end

	def time_now
		Time.now.to_i
	end

	def day(day_counter = 0)
		@db[(today_key.to_i + day_counter * 24 * 60 * 60).to_s]
	end

	def on
		today["on"]
	end

	def turn_on
		today["on"] = true
	end

	def turn_off
		today["on"] = false
	end
end