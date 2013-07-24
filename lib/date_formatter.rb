class DateFormatter

	def self.parse_hour(timestamp)
		Time.at(timestamp).to_s.split[1]
	end

	def self.parse_date(timestamp)
		Time.at(timestamp).to_s.split[0]
	end

	def self.parse_relative_date(day_counter = 0, today = Time.new)
		#today = today ? today : Time.new
		passed_days = day_counter * 60 * 60 * 24
		parse_date(today.to_i + passed_days)
	end

	def self.parse_elapsed_time(duration)
		"#{hours(duration)}h #{minutes(duration)}min #{seconds(duration)}sec"
	end

	def self.round_duration(duration)
		hours = hours(duration)
		part = (minutes(duration) / 60.0) * 10
		if part > 5
			hours += 1
			part = 0
		elsif part < 5 && part > 0
			part = 5
		end
		part == 0 ? hours.to_s : "#{hours}.#{part}"
	end

	private
	def self.hours(duration)
		duration / 3600
	end

	def self.minutes(duration)
		(duration % 3600) / 60
	end

	def self.seconds(duration)
		duration % 60
	end
end