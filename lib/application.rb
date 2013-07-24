require_relative 'argument_parser'
require_relative 'timer'
require_relative 'date_formatter'
require_relative 'database'

class Application
  DATABASE_PATH = ENV["HOME"] + "/.timert"

	def initialize(argv)
    @database = Database.new(DATABASE_PATH)    
    @timer = Timer.new(@database.today)
    parser = ArgumentParser.new(argv)
    send(parser.action, parser.argument) if parser.action
	end

  private
  def start(time = nil)
    result = @timer.start
    if result["started"]
      puts "start timer at #{parse_hour(result["time"])}"
      @database.save_day(@timer.today)
    else
      puts "timer already started at #{parse_hour(result["time"])}"
    end
  end

  def stop(time = nil)
    result = @timer.stop
    if result["stopped"]
      puts "stop timer at #{parse_hour(result["time"])}"
      @database.save_day(@timer.today)
    else
      puts "timer isn't started yet"
    end

  end

  def report(day_counter = 0)
    puts "REPORT FOR #{parse_relative_date(day_counter)}"    
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
