class DateFormatter

	def self.parse_hour(timestamp)
		Time.at(timestamp).to_s.split[1]
	end

	def self.parse_relative_date(day_counter = 0, today = Time.new)
		#today = today ? today : Time.new
		passed_days = day_counter * 60 * 60 * 24
		Time.at(today.to_i + passed_days).to_s.split[0]		
	end

	def self.parse_elapsed_time(duration)
		hours = duration / 3600
		minutes = (duration % 3600) / 60
		seconds = duration % 60
		"#{hours}h #{minutes}min #{seconds}sec"
	end
end