require 'json'
require 'date'
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

	it "should know if it's on" do
		@timer.start
		expect(@timer.is_on?).to eq(true)
	end
#implmentation detail
	it 'should preserve status between inits' do
		@timer.start
		init_timer
		expect(@timer.is_on?).to eq(true)
		init_timer
		expect(@timer.is_on?).to eq(true)		
	end

	it 'should return hash when report method is called' do
		expect(@timer.report.instance_of?(Hash)).to eq(true)
	end

	it 'should save reports from the past days' do
		write_data_file(sample_data_with_yesterday)
		expect(@timer.report(-1).instance_of?(Hash)).to eq(true)
	end

	it 'should save start time' do
		time = @timer.start
		expect(@timer.current_interval["start"]).to eq(time)
	end

	it "should not start again if it's already started" do
		expect(@timer.start.instance_of?(Fixnum)).to eq(true)
		expect(@timer.start.instance_of?(Fixnum)).not_to eq(true)
	end

	it 'should save stop time' do
		@timer.start
		time = @timer.stop
		expect(@timer.current_interval["stop"]).to eq(time)
	end

	it 'should say how much time elapsed today' do
		write_data_file(sample_data_with_yesterday)
		init_timer
		expect(@timer.report["total_elapsed_time"]).to eq(3 * 60 * 60 + 25 * 60 + 13)
	end

	it 'should say how much time elapsed in one of the past days' do
		write_data_file(sample_data_with_yesterday)
		init_timer
		expect(@timer.report(-1)["total_elapsed_time"]).to eq(3 * 60 * 60 + 25 * 60 + 13)
	end

	it "should show today's tasks" do
		@timer.add_task("buy apples")
		@timer.add_task("write emails")
		@timer.add_task("sleep")
		expect(@timer.report["tasks"]).to eq(["buy apples", "write emails", "sleep"])
	end

	it "should show past tasks" do
		write_data_file(sample_data_with_yesterday)		
		init_timer
		expect(@timer.report(-1)["tasks"]).to eq(["emails", "meeting with the team"])
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

	def today
		Date.today.to_time.to_i.to_s
	end

	def yesterday
		Time.at(Date.today.to_time.to_i - 60 * 60 * 24).to_i.to_s
	end

# Timecop
	def sample_data_with_yesterday
		stop = Time.now.to_i
		start = stop - 3 * 60 * 60 - 25 * 60 - 13
		{ 
			today => { 
				"intervals" => [{"start" => start, "stop" => stop }]
			},
			yesterday => { 
				"tasks" => ["emails", "meeting with the team"],
				"intervals" => [{"start" => start, "stop" => stop}]
			}
		}
	end
end