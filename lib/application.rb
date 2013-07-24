require_relative 'argument_parser'
require_relative 'timer'
require_relative 'date_formatter'
require_relative 'database'

class Application
  attr_reader :result

  def initialize(argv, db_path)
    @database = Database.new(db_path)    
    @timer = Timer.new(@database.today)
    @result = {}
    
    parser = ArgumentParser.new(argv)
    send(parser.action, parser.argument) if parser.action
  end

  private
  def start(time = nil)
    timer_result = @timer.start
    if timer_result["started"]
      @result["message"] = "start timer at #{parse_hour(timer_result["time"])}"
      @database.save_today(@timer.today)
    else
      @result["message"] = "timer already started at #{parse_hour(timer_result["time"])}"
    end    
  end

  def stop(time = nil)
    timer_result = @timer.stop
    if timer_result["stopped"]      
      @result["message"] = "stop timer at #{parse_hour(timer_result["time"])}"
      @database.save_today(@timer.today)
    else
      @result["message"] = "timer isn't started yet"
    end    
  end

  def report(day_counter = 0)
    @message = "REPORT FOR #{parse_relative_date(day_counter)}"    
  end

	def add_task(task)    
    puts "added task: #{task}"
    @timer.add_task(task)
    @database.save_day(@timer.today)
	end

  def parse_hour(timestamp)
    DateFormatter.parse_hour(timestamp)
  end

  def parse_relative_date(day_counter)
    DateFormatter.parse_relative_date(day_counter.to_i)
  end
end
