require 'timecop'

require_relative '../lib/report'
require_relative '../lib/database'
require_relative '../lib/day'

describe Report do
	let(:path) { './spec/data/timert' }
	let(:database) { 
		db = Database.new(path) 
		day = Day.new
		day.add_start(Time.new(2013, 2, 20, 14, 00).to_i)
		day.add_stop(Time.new(2013, 2, 20, 15, 13).to_i)
		day.add_start(Time.new(2013, 2, 20, 16, 4, 24).to_i)
		day.add_stop(Time.new(2013, 2, 20, 18, 45).to_i)
		day.add_task("emails")
		day.add_task("meeting")
		Timecop.freeze(Time.new(2013, 2, 20, 19)) do
			db.save_today(day)
		end
		db
	}

	before(:each) do
		database
		Timecop.freeze(Time.new(2013, 2, 20))
	end

	after(:each) do
		Timecop.return
		File.delete(path)
	end

	it 'should give report for today' do
		expect(Report.generate(database).instance_of?(String)).to eq(true)
	end
end