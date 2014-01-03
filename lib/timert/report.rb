require 'colorize'
require 'date'
require_relative 'date_util'
require_relative 'duration'

module Timert
  class Report

    def self.generate(database, time_expression = "")
      time_expression = time_expression.to_s
      if time_expression.include?("month")
        report_for_month(database, time_expression)
      elsif time_expression.include?("week")
        report_for_week(database, time_expression)
      else
        report_for_day(database, time_expression.to_i)
      end
    end

    private
    def self.report_for_week(database, time_expression = "")
      week_nr = extract_time_modifier(time_expression)
      today = Date.today
      first = today - today.cwday + 1 + week_nr * 7
      last = first + 6

      title = week_nr != 0 ? "REPORT FOR WEEK #{format_date(first)} - #{format_date(last)}" : "REPORT FOR THIS WEEK"
      "#{title}\n".blue +
        report_for_range(Range.new(first, last), database)
    end

    def self.report_for_month(database, time_expression = "")
      month_nr = extract_time_modifier(time_expression)
      today = Date.today
      first = Date.new(today.year, today.month, 1) << -month_nr
      last = Date.new(today.year, today.month, -1) << -month_nr

      title = month_nr != 0 ? "REPORT FOR MONTH #{format_month(first)}" : "REPORT FOR THIS MONTH"
      "#{title}\n".blue +
        report_for_range(Range.new(first, last), database)
    end

    def self.report_for_range(range, database)
      days = database.days(range)

      s = "\nDay/time elapsed\n".green
      total_time, total_rounded_duration = 0, 0

      days.each do |day|
        duration = duration(day.total_elapsed_time)
        s += "#{format_date(day.date)}: ".yellow +
          "#{duration.to_s} / #{duration.round} " +
          "(#{format_tasks(day)})\n"
        total_time += duration.value
        total_rounded_duration += duration.round.to_f
      end

      s += "\nTotal:\n".green
      s += "#{parse_duration(total_time)} / #{total_rounded_duration}"
      s
    end

    def self.report_for_day(database, day_counter = 0)
      date = Date.today + day_counter
      day = database.day(date)
      if day
        "REPORT FOR #{format_date(date)}\n".blue +
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
        start = DateUtil.format_hour(i["start"])
        stop = DateUtil.format_hour(i["stop"])
        s += "#{start} - #{stop}\n"
      end
      s
    end

    def self.format_date(date)
      DateUtil.format_date(date)
    end

    def self.format_month(date)
      DateUtil.format_month(date)
    end

    def self.parse_duration(duration)
      duration(duration).to_s
    end

    def self.duration(duration)
      Duration.new(duration)
    end

    def self.round_duration(duration)
      duration(duration).round
    end

    def self.extract_time_modifier(time_expression)
      if time_expression.include?(" ")
        time_expression.split(" ")[1].to_i
      else
        0
      end
    end
  end
end
