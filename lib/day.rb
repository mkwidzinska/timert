class Day

	attr_reader :intervals, :tasks
	attr_accessor :on

	def initialize(args = {})		
		@intervals = args[:intervals] || []
		@tasks = args[:tasks] || []		
	end

	def add_start(time)
		if !is_interval_started?
			if time < last_start
				raise ArgumentError.new("Invalid start time")
			end
			@intervals.push({"start" => time}) 
			time
		end
	end

	def add_stop(time)
		if is_interval_started?			
			if time < last_start
				raise ArgumentError.new("Invalid stop time")
			end
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
			"tasks" => @tasks,
			"intervals" => @intervals
		}
	end

	def is_interval_started?
		@intervals.length > 0 && 
			@intervals.last["start"] && 
			!@intervals.last["stop"]
	end

	def ==(other)
		other.to_hash == to_hash
	end

	def last_start
		last_interval['start'].to_i
	end	

	def last_stop
		last_interval['stop'].to_i
	end

	private 
	def interval_duration(interval)
		interval["stop"].to_i - interval["start"].to_i		
	end

	def last_interval
		@intervals.length > 0 ? @intervals.last : {}
	end
end