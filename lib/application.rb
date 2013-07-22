require_relative 'argument_parser'
require_relative 'timer'
require_relative 'date_formatter'

class Application
  DATABASE_PATH = ENV["HOME"] + "/.timert"

	def initialize(argv)
    @timer = Timer.new(DATABASE_PATH)
    parser = ArgumentParser.new(argv)
    send(parser.action, parser.argument) if parser.action
	end

  private
  def start(time = nil)
    time = @timer.start # return time and flag
    if time
      puts "start timer at #{parse_hour(time)}"
    else
      start = @timer.current_interval["start"]
      puts "timer already started at #{parse_hour(start)}"
    end
  end

  def stop(time = nil)
    time = @timer.stop
    puts "stop timer at #{parse_hour(time)}"
  end

  def report(day_counter)
    day_counter ||= 0
    puts "REPORT FOR #{parse_relative_date(day_counter)}"
    puts @timer.report(day_counter.to_i)
  end

	def add_task(task)    
    puts "added task: #{task}"
    @timer.add_task(task)
	end

  def parse_hour(timestamp)
    DateFormatter.parse_hour(timestamp)
  end

  def parse_relative_date(day_counter)
    DateFormatter.parse_relative_date(day_counter.to_i)
  end
end
