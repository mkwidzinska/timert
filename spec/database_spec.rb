require 'timecop'
require 'date'

require_relative '../lib/database'
require_relative '../lib/day'

describe Database do
	before(:each) do
		@path = "./spec/data/test_data"
		@db = Database.new(@path)		
	end

	after(:each) do
		File.delete(@path)
	end

	it 'should have a method for getting the current day' do
		write_day = Day.new(tasks: ["emails"])		
		@db.save_today(write_day)
		read_day = @db.day
		expect(write_day.to_hash).to eq(read_day.to_hash)
	end

	it 'should have a method for getting one of the past days' do
		write_day = Timecop.freeze(Time.new(2013, 8, 12, 12)) do
			@db.save_today(Day.new(tasks: ["meeting"]))		
			@db.day
		end
		read_day = Timecop.freeze(Time.new(2013, 8, 14, 12)) do
			@db.day(-2)
		end
		expect(write_day).to eq(read_day)
	end

	it 'should save current day' do
		day = Day.new(tasks: ["emails", "reading"])
		@db.save_today(day)
		expect(@db.day).to eq(day)
	end

	it 'should have a method for getting a range of days' do
		first = {
			"day" => Day.new(tasks: "emails"),
			"date" => Date.new(2013, 9, 10).to_time.to_i
		}
		second = {
			"day" => Day.new(tasks: "meetings"),
			"date" => Date.new(2013, 9, 11, 11).to_time.to_i
		}
		
		past = Timecop.freeze(Time.at(first["date"])) do
			@db.save_today(first["day"])
			(Date.today - 5).to_time.to_i
		end
		
		present = Timecop.freeze(Time.at(second["date"])) do
			@db.save_today(second["day"])
			Date.today.to_time.to_i
		end
		
		expect(@db.days(Range.new(past, present))).to eq([first, second])
	end
end