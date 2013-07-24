class Day

	attr_reader :intervals, :tasks
	attr_accessor :on

	def initialize(args = {})		
		@intervals = args[:intervals] || []
		@tasks = args[:tasks] || []
		@on = args[:on] || false				
	end

	def add_start(time)
		if !is_interval_started?
			@intervals.push({"start" => time}) 
			time
		end
	end

	def add_stop(time)
		if is_interval_started?
			@intervals.last["stop"] = time 
			time
		end
	end

	def total_elapsed_time
		total = 0
		@intervals.each { |i| total += interval_duration(i) }
		total
	end

	def add_task(task)
		@tasks.push(task)
	end

	def to_hash
		{
			"on" => @on,
			"tasks" => @tasks,
			"intervals" => @intervals
		}
	end

	private 
	def is_interval_started?
		@intervals.length > 0 && 
			@intervals.last["start"] && 
			!@intervals.last["stop"]
	end

	def interval_duration(interval)
		diff = interval["stop"].to_i - interval["start"].to_i
		diff > 0 ? diff : 0
	end
end