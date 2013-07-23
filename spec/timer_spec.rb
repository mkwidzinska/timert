require 'json'
require 'timecop'
require_relative '../lib/timer'

describe Timer do
	before(:each) do
		@path = "./spec/data/test_data"
		@timer = Timer.new(@path)
	end

	it 'should have access to a database file' do
		expect(File.exists?(@timer.path)).to eq(true)
	end
	
	it 'should return hash when report method is called' do
		expect(@timer.report.instance_of?(Hash)).to eq(true)
	end

	it 'should save reports from the past days' do
		Timecop.freeze(Time.new(2013, 6, 10, 14, 56)) do
			@timer.start
		end
		Timecop.freeze(Time.new(2013, 6, 10, 16, 14)) do
			@timer.stop
			@timer.add_task("debugging")
		end
		Timecop.freeze(Time.new(2013, 6, 11, 16, 14)) do
			expect(@timer.report(-1).instance_of?(Hash)).to eq(true)
		end
	end

	it 'should return start time when started' do		
		Timecop.freeze(Time.new(2013, 2, 14, 22, 0)) do
			expect(@timer.start).to eq(Time.now.to_i)
		end
	end

	it 'should return start time when stopped' do		
		Timecop.freeze(Time.new(2013, 2, 14, 22, 0)) do
			@timer.start
			expect(@timer.stop).to eq(Time.now.to_i)
		end
	end

	it 'should save start time' do
		time = @timer.start
		expect(@timer.report["intervals"].last["start"]).to eq(time)
	end

	context 'while running' do
		before do
			@timer.start
		end

		it "should return nil when started again" do
			expect(@timer.start.instance_of?(Fixnum)).not_to eq(true)
		end

		it "should not change report when started again" do
			expect { @timer.start }.to_not change(@timer, :report)
		end	
	end	

	it "should not change report when stopped while stopped already" do
		expect { @timer.stop }.to_not change(@timer, :report)
	end	

	it 'should save stop time' do
		@timer.start
		time = @timer.stop
		expect(@timer.report["intervals"].last["stop"]).to eq(time)
	end

	it 'should say how much time elapsed today' do
		Timecop.freeze(Time.new(2013, 4, 10, 14, 20, 10)) do
			@timer.start
		end
		Timecop.freeze(Time.new(2013, 4, 10, 17, 15, 16)) do
			@timer.stop
			expect(@timer.report["total_elapsed_time"]).to eq(duration(2, 55, 6))		
		end
	end

	it 'should say how much time elapsed in one of the past days' do
		Timecop.freeze(Time.new(2013, 4, 5, 13, 0, 0)) do
			@timer.start
		end
		Timecop.freeze(Time.new(2013, 4, 5, 16, 25, 13)) do
			@timer.stop
		end
		Timecop.freeze(Time.new(2013, 4, 10, 13))	do
			expect(@timer.report(-5)["total_elapsed_time"]).to eq(duration(3, 25, 13))		
		end
	end

	it "should show today's tasks" do
		@timer.add_task("buy apples")
		@timer.add_task("write emails")
		@timer.add_task("sleep")
		expect(@timer.report["tasks"]).to eq(["buy apples", "write emails", "sleep"])
	end

	it "should show past tasks" do		
		Timecop.freeze(Time.new(2013, 5, 15, 15, 45)) do
			@timer.add_task("emails")			
			@timer.add_task("meeting with the team")
		end
		Timecop.freeze(Time.new(2013, 5, 16, 10, 9)) do
			expect(@timer.report(-1)["tasks"]).to eq(["emails", "meeting with the team"])
		end
	end

	after(:each) do
		File.delete(@timer.path)
	end	

	def duration(hours, minutes, seconds)
		hours * 60 * 60 + minutes * 60 + seconds
	end
end