require_relative '../lib/database'
require_relative '../lib/day'

describe Database do
	before(:each) do
		@db = Database.new("./spec/data/test_data")		
	end

	it 'should have a method for getting the current day' do
		write_day = Day.new(tasks: ["emails"])		
		@db.save_day(write_day)
		read_day = @db.day
		expect(write_day.to_hash).to eq(read_day.to_hash)
	end

	it 'should have a method for getting past days' do
		write_day = Day.new(tasks: ["meeting"])		
		@db.save_day(write_day, -2)
		read_day = @db.day(-2)
		expect(write_day.to_hash).to eq(read_day.to_hash)
	end

	it 'should save current day' do
		day = Day.new(tasks: ["emails", "reading"])
		@db.save_day(day)
		expect(@db.day).to eq(day)
	end
end