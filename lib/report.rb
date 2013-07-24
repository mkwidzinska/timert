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
		first = (today - today.cwday).to_time.to_i
		last = (today + 7 - today.cwday - 1).to_time.to_i
		"REPORT FOR THIS WEEK\n".blue +
		report_for_range(Range.new(first, last), database)
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
			day = d["day"]
			s += "#{parse_date(d["date"])}: ".yellow + 
				"#{parse_duration(day.total_elapsed_time)} " +
				"(#{format_tasks(day)})\n"
			total_time += d["day"].total_elapsed_time
		end
		
		s += "\nTotal:\n".green
		s += parse_duration(total_time)
		s
	end

	def self.report_for_day(database, day_counter = 0)
		day = database.day(day_counter)
		if day			
			"REPORT FOR #{relative_date(day_counter)}:\n".blue + 
			 "Tasks:\n".green + 
			"#{format_tasks(day)}\n" + 
			"\nWork time:\n".green + 
			"#{format_intervals(day)}" + 
			"\nTotal elapsed time:\n".green + 
			"#{parse_duration(day.total_elapsed_time)}\n" + 
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

	def self.parse_date(timestamp)
		DateFormatter.parse_date(timestamp)
	end

	def self.relative_date(day_counter)
		DateFormatter.parse_relative_date(day_counter)
	end

	def self.parse_duration(duration)
		DateFormatter.parse_elapsed_time(duration)
	end
end