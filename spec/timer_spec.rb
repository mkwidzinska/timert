require 'json'
require 'timecop'
require_relative '../lib/timer'

describe Timer do
	let(:init_test_timer) { init_timer }

	before(:each) do
		@path = "./spec/data/test_data"
		init_timer
	end

	it 'should have access to a database file' do
		expect(File.exists?(@timer.path)).to eq(true)
	end
	
	it 'should return hash when report method is called' do
		expect(@timer.report.instance_of?(Hash)).to eq(true)
	end

	it 'should save reports from the past days' do
		Timecop.freeze(Time.new(2013, 6, 10, 14, 56))
		@timer.start
		Timecop.freeze(Time.new(2013, 6, 10, 16, 14))
		@timer.stop
		@timer.add_task("debugging")
		Timecop.freeze(Time.new(2013, 6, 11, 16, 14))
		expect(@timer.report(-1).instance_of?(Hash)).to eq(true)
		Timecop.return
	end

	it 'should save start time' do
		time = @timer.start
		expect(@timer.report["intervals"].last["start"]).to eq(time)
	end

	it "should not start again if it's already started" do
		expect(@timer.start.instance_of?(Fixnum)).to eq(true)
		expect(@timer.start.instance_of?(Fixnum)).not_to eq(true)
	end

	it 'should save stop time' do
		@timer.start
		time = @timer.stop
		expect(@timer.report["intervals"].last["stop"]).to eq(time)
	end

	it 'should say how much time elapsed today' do
		init_timer
		t = Time.now
		Timecop.freeze(Time.new(2013, 4, 10, 14, 20, 10))
		@timer.start
		Timecop.freeze(Time.new(2013, 4, 10, 17, 45, 23))
		@timer.stop
		expect(@timer.report["total_elapsed_time"]).to eq(3 * 60 * 60 + 25 * 60 + 13)
		Timecop.return
	end

	it 'should say how much time elapsed in one of the past days' do
		init_timer
		Timecop.freeze(Time.new(2013, 4, 5, 13, 0, 0))
		@timer.start
		Timecop.freeze(Time.new(2013, 4, 5, 16, 25, 13))
		@timer.stop
		Timecop.freeze(Time.new(2013, 4, 10, 13))		
		expect(@timer.report(-5)["total_elapsed_time"]).to eq(3 * 60 * 60 + 25 * 60 + 13)
		Timecop.return
	end

	it "should show today's tasks" do
		@timer.add_task("buy apples")
		@timer.add_task("write emails")
		@timer.add_task("sleep")
		expect(@timer.report["tasks"]).to eq(["buy apples", "write emails", "sleep"])
	end

	it "should show past tasks" do
		init_timer
		Timecop.freeze(Time.new(2013, 5, 15, 15, 45))
		@timer.add_task("emails")
		@timer.add_task("meeting with the team")
		Timecop.freeze(Time.new(2013, 5, 16, 10, 9))
		expect(@timer.report(-1)["tasks"]).to eq(["emails", "meeting with the team"])
		Timecop.return
	end

	after(:each) do
		File.delete(@timer.path)
	end	

	def init_timer
		@timer = Timer.new(@path)
	end

	def write_data_file(data)
		File.open(@path, "w+") { |file| file.write(data.to_json) }
	end	
end