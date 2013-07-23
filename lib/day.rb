class Day

	attr_reader :intervals, :tasks
	attr_accessor :on

	def initialize
		@intervals = []
		@tasks = []
	end

	def add_start(time)
		@intervals.push({"start" => time}) if is_last_interval_finished?
	end

	def add_stop(time)
		@intervals.last["stop"] = time
	end

	def total_elapsed_time
		total = 0
		@intervals.each { |i| total += interval_duration(i) }
		total
	end

	def add_task(task)
		@tasks.push(task)
	end

	private 
	def is_last_interval_finished?
		@intervals.length == 0 || 
		(@intervals.last["start"] && @intervals.last["stop"])
	end

	def interval_duration(interval)
		diff = interval["stop"].to_i - interval["start"].to_i
		diff > 0 ? diff : 0
	end
end