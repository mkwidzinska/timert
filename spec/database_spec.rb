require 'timecop'

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

	it 'should have a method for getting past days' do
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

end