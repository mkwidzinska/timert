require 'json'
require 'timecop'
require_relative '../lib/timer'
require_relative '../lib/day'

describe Timer do
	before(:each) do
		@today = Day.new
		@timer = Timer.new(@today)
	end	

	it 'should return start time when started' do		
		Timecop.freeze(Time.new(2013, 2, 14, 22, 0)) do
			expect(@timer.start["time"]).to eq(Time.now.to_i)
		end
	end

	it 'should return stop time when stopped' do		
		Timecop.freeze(Time.new(2013, 2, 14, 22, 0)) do
			@timer.start
		end
		Timecop.freeze(Time.new(2013, 2, 15, 22, 0)) do
			expect(@timer.stop["time"]).to eq(Time.now.to_i)
		end
	end

	context 'while running' do
		before do
			@timer.start
		end

		it "should not start again until it's stopped" do
			expect(@timer.start["started"]).to eq(false)
			@timer.stop
			expect(@timer.start["started"]).to eq(true)
		end		
	end	

	context 'while not running' do
		it "should not stop until it's started" do
			expect(@timer.stop["stopped"]).to eq(false)
			@timer.start
			expect(@timer.stop["stopped"]).to eq(true)
		end
	end	

	it 'should be able to start with given time' do
		time = Time.now.to_i
		expect(@timer.start(time)["time"]).to eq(time)
	end

	it 'should be able to stop with given time' do
		@timer.start
		time = Time.now.to_i + 500
		expect(@timer.stop(time)["time"]).to eq(time)
	end
end