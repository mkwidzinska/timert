require 'colorize'
require 'date'
require_relative 'date_formatter'

class Report
  
  def self.generate(database, time_expression = "")
    if time_expression == "month"
      report_for_month(database)
    elsif time_expression == "week"
      report_for_week(database)
    else 
      report_for_day(database, time_expression.to_i)
    end
  end

  private
  def self.report_for_week(database)
    today = Date.today
    first = today - today.cwday
    last = first + 6
    "REPORT FOR THIS WEEK\n".blue +
      report_for_range(Range.new(first.to_time.to_i, last.to_time.to_i), database)
  end

  def self.report_for_month(database)
    today = Date.today
    first = Date.new(today.year, today.month, 1).to_time.to_i 
    last = Date.new(today.year, today.month, -1).to_time.to_i     
    "REPORT FOR THIS MONTH\n".blue +
      report_for_range(Range.new(first, last), database)
  end

  def self.report_for_range(range, database)
    data = database.days(range)
    
    s = "\nDay/time elapsed\n".green
    total_time = 0
    
    data.each do |d|
      date, day = d["date"], d["day"]
      s += "#{parse_date(date)}: ".yellow + 
        "#{parse_duration(day.total_elapsed_time)} " +
        "(#{format_tasks(day)})\n"
      total_time += day.total_elapsed_time
    end
    
    s += "\nTotal:\n".green
    s += parse_duration(total_time)
    s
  end

  def self.report_for_day(database, day_counter = 0)
    date = Date.today + day_counter
    day = database.day(date)
    if day      
      "REPORT FOR #{parse_date(date)}\n".blue + 
        "\nTasks:\n".green + 
        "#{format_tasks(day)}\n" + 
        "\nWork time:\n".green + 
        "#{format_intervals(day)}" + 
        "\nTotal elapsed time:\n".green + 
        "#{parse_duration(day.total_elapsed_time)}\n" + 
        "\nSummary:\n".red + 
        "#{round_duration(day.total_elapsed_time)} #{format_tasks(day)}"
    else
      "No data"    
    end
  end

  def self.format_tasks(day)
    day.tasks.length > 0 ? day.tasks.join(", ") : "-"
  end

  def self.format_intervals(day)
    s = ""
    day.intervals.each do |i| 
      start = DateFormatter.parse_hour(i["start"])
      stop = DateFormatter.parse_hour(i["stop"])
      s += "#{start} - #{stop}\n"
    end
    s
  end  

  def self.parse_date(date)
    DateFormatter.parse_date(date)
  end

  def self.parse_duration(duration)
    DateFormatter.parse_elapsed_time(duration)
  end

  def self.round_duration(duration)
    DateFormatter.round_duration(duration)
  end
end