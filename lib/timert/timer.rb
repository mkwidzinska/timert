module Timert
  class Timer
    attr_reader :path, :today

    def initialize(today)
      @today = today
    end

    def start(time = nil)
      if !on?
        started = true
        today.add_start(time || now)
      end
      {time: today.last_start, started: started}
    end

    def stop(time = nil)
      if on?
        stopped = true
        today.add_stop(time || now)
      end
      {time: today.last_stop, stopped: stopped}
    end

    def add_task(task)
      today.add_task(task)
    end

    private
    def now
      Time.now.to_i
    end

    def on?
      today.is_interval_started?
    end
  end
end