require 'json'
require 'date'
require_relative 'day'

class Timer	
	attr_reader :path

	def initialize(today = nil)
		@today = today || Day.new
	end

	def start(time = nil)
		time ||= time_now
		if !on?
			started = true
			today.add_start(time)					
		end
		{"time" => today.last_start, "started" => started || false}
	end

	def stop(time = nil)
		time ||= time_now
		if on?
			stopped = true
			time = today.add_stop(time)			
		end
		{"time" => time || 0, "stopped" => stopped || false}
	end

	def add_task(task)
		today.add_task(task)		
	end

	def today
		@today
	end

	private	
	def time_now
		Time.now.to_i
	end

	def on?
		today.is_interval_started?
	end	
end