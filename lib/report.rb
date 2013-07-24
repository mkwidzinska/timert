require 'colorize'
require 'date'
require 'date_formatter'

class Report
	
	def self.generate(database, day_counter = 0)
		day = database.day(day_counter)
		if day			
			"REPORT FOR #{DateFormatter.parse_relative_date(day_counter)}:\n".blue + 
			"Tasks:\n".green + 
			"#{format_tasks(day)}\n" + 
			"Work time:\n".green + 
			"#{format_intervals(day)}" + 
			"Total elapsed time:\n".green + 
			"#{DateFormatter.parse_elapsed_time(day.total_elapsed_time)}\n" + 
			"Summary:\n".red + 
			"#{DateFormatter.round_duration(day.total_elapsed_time)} #{format_tasks(day)}"
		else
			"No data"		
		end
	end

	private
	def self.format_tasks(day)
		day.tasks.join(", ")
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