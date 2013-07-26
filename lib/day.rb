class Day

  attr_reader :intervals, :tasks
  attr_accessor :on

  def initialize(args = {})    
    @intervals = args[:intervals] || []
    @tasks = args[:tasks] || []    
  end

  def add_start(time)
    if !is_interval_started?
      if time <= last_start
        raise ArgumentError.new("Invalid start time")
      elsif time < last_stop
        raise ArgumentError.new("Invalid start time. It's before the last stop time.")
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
    start, stop = interval["start"], interval["stop"]
    if start      
      stop ||= interval_end_when_start(start)
      stop.to_i - start.to_i    
    else
      0
    end
  end

  def last_interval
    @intervals.length > 0 ? @intervals.last : {}
  end

  def interval_end_when_start(timestamp)
    day_is_today?(timestamp) ? Time.now.to_i : last_second_of_day(timestamp)    
  end

  def day_is_today?(timestamp)
    Time.now.to_date == Time.at(timestamp).to_date
  end

  def last_second_of_day(timestamp)
    time = Time.at(timestamp)
    Time.new(time.year, time.month, time.day, 23, 59, 59)
  end
end