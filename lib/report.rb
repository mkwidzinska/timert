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
		"week report"
	end

	def self.report_for_month(database)
		"month report"
	end

	def self.report_for_day(database, day_counter = 0)
		day = database.day(day_counter)
		if day			
			"REPORT FOR #{DateFormatter.parse_relative_date(day_counter)}:\n".blue + 
			 "Tasks:\n".green + 
			"#{format_tasks(day)}\n" + 
			"\nWork time:\n".green + 
			"#{format_intervals(day)}" + 
			"\nTotal elapsed time:\n".green + 
			"#{DateFormatter.parse_elapsed_time(day.total_elapsed_time)}\n" + 
			"\nSummary:\n".red + 
			"#{DateFormatter.round_duration(day.total_elapsed_time)} #{format_tasks(day)}"
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
end