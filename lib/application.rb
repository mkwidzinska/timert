require_relative 'argument_parser'
require_relative 'timer'
require_relative 'date_formatter'
require_relative 'database'
require_relative 'report'

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
    begin
      timer_result = @timer.start(time)
      if timer_result["started"]
        @result["message"] = "start timer at #{parse_hour(timer_result["time"])}"
        @database.save_today(@timer.today)
      else
        @result["message"] = "timer already started at #{parse_hour(timer_result["time"])}"
      end    
    rescue ArgumentError => e
      @result["message"] = e.message
    end
  end

  def stop(time = nil)
    begin
      timer_result = @timer.stop(time)
      if timer_result["stopped"]      
        @result["message"] = "stop timer at #{parse_hour(timer_result["time"])}"
        @database.save_today(@timer.today)
      else
        @result["message"] = "timer isn't started yet"
      end    
    rescue ArgumentError => e
      @result["message"] = e.message
    end
  end

  def report(day_counter = 0)
    @result["message"] = Report.generate(@database, day_counter.to_i)    
  end

	def add_task(task)    
    @result["message"] = "added task: #{task}"
    @timer.add_task(task)
    @database.save_today(@timer.today)
	end

  def parse_hour(timestamp)
    DateFormatter.parse_hour(timestamp)
  end

  def parse_relative_date(day_counter)
    DateFormatter.parse_relative_date(day_counter.to_i)
  end
end
