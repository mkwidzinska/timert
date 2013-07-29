require_relative 'argument_parser'
require_relative 'timer'
require_relative 'date_util'
require_relative 'database'
require_relative 'report'
require_relative 'help'

class Application
  attr_reader :result

  def initialize(argv, db_path)
    @database = Database.new(db_path)    
    @timer = Timer.new(@database.today)
    @result = {}

    parser = ArgumentParser.new(argv)
    send(parser.action, *[parser.argument].compact)
  end

  private
  def start(time = nil)
    begin
      timer_result = @timer.start(time)
      if timer_result[:started]
        add_message("start timer at #{format_hour(timer_result[:time])}")
        @database.save_today(@timer.today)
      else
        add_message("timer already started at #{format_hour(timer_result[:time])}")
      end    
    rescue ArgumentError => e
      add_message(e.message)
    end
  end

  def stop(time = nil)
    begin
      timer_result = @timer.stop(time)
      if timer_result[:stopped]      
        add_message("stop timer at #{format_hour(timer_result[:time])}")
        @database.save_today(@timer.today)
      else
        add_message("timer isn't started yet")
      end    
    rescue ArgumentError => e
      add_message(e.message)
    end
  end

  def report(time_expression)
    add_message(Report.generate(@database, time_expression))
  end

  def add_task(task)    
    add_message("added task: #{task}")
    @timer.add_task(task)
    @database.save_today(@timer.today)
  end

  def help
    add_message(Help.generate)
  end

  def format_hour(timestamp)
    DateUtil.format_hour(timestamp)
  end

  def add_message(msg)
    @result["message"] = msg
  end  
end
