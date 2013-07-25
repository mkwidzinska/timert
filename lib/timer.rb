require 'json'
require 'date'
require_relative 'day'

class Timer  
  attr_reader :path

  def initialize(today = nil)
    @today = today || Day.new
  end

  def start(time = nil)
    if !on?
      started = true
      today.add_start(time || now)          
    end
    {"time" => today.last_start, "started" => started || false}
  end

  def stop(time = nil)
    if on?
      stopped = true
      today.add_stop(time || now)
    end
    {"time" => today.last_stop || 0, "stopped" => stopped || false}
  end

  def add_task(task)
    today.add_task(task)    
  end

  def today
    @today
  end

  private  
  def now
    Time.now.to_i
  end

  def on?
    today.is_interval_started?
  end  
end