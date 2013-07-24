require_relative '../lib/day'

describe Day do
	before(:each) do
		@day = Day.new
	end
	
	it 'should have method intervals that returns array' do
		expect(@day.intervals.instance_of?(Array)).to eq(true)
	end

	context 'after at least one start and stop time has been added' do
		before	do
			@day.add_start(Time.now.to_i)
			@day.add_stop(Time.now.to_i + 100)
		end

		it 'should have method intervals that contains hash with start and stop times' do
			expect(@day.intervals.last["start"]).to_not eq(nil)
			expect(@day.intervals.last["stop"]).to_not eq(nil)
		end
	end

	it "should not add start time when last interval hasn't been completed" do
		time = Time.now.to_i
		@day.add_start(time)
		expect(@day.intervals.length).to eq(1)
		@day.add_start(time)
		expect(@day.intervals.length).to eq(1)
	end

	it "should not add stop time when no interval is started" do
		time = Time.now.to_i
		@day.add_start(time)
		@day.add_stop(time + 100)
		@day.add_stop(time + 200)
		expect(@day.intervals.length).to eq(1)
		expect(@day.intervals.last["stop"]).to eq(time + 100)
	end

	it 'should have a method that returns total elapsed time' do
		@day.add_start(Time.new(2013, 6, 10, 12, 34).to_i)
		@day.add_stop(Time.new(2013, 6, 10, 14, 51, 10).to_i)
		@day.add_start(Time.new(2013, 6, 10, 16, 10, 20).to_i)
		@day.add_stop(Time.new(2013, 6, 10, 17, 15, 41).to_i)		
		expect(@day.total_elapsed_time).to eq(duration(3, 22, 31))
	end

	it 'should have task method that returns an array' do
		expect(@day.tasks.instance_of?(Array)).to eq(true)		
	end

	it 'should add tasks' do
		@day.add_task("watching youtube")
		@day.add_task("walking the dog")
		expect(@day.tasks).to eq(["watching youtube", "walking the dog"])
	end

	context 'after initialized with hash data' do
		before do
			@day = Day.new(
				intervals: [{"start" => 124, "stop" => 1300}],
				tasks: ["debugging", "emails"]
			)			
		end

		it 'should contain appropiate data' do
			expect(@day.intervals.last["start"]).to eq(124)
			expect(@day.intervals.last["stop"]).to eq(1300)
			expect(@day.tasks).to eq(["debugging", "emails"])			
		end

		it "should have to_hash method that returns day's state" do
			hash = {
				"intervals" => [{"start" => 124, "stop" => 1300}],
				"tasks" => ["debugging", "emails"]				
			}
			expect(@day.to_hash).to eq(hash)			
		end
	end

	it "should return start time when it's added" do
		time = Time.now.to_i
		expect(@day.add_start(time)).to eq(time)
	end

	it "should return stop time when it's added" do
		time = Time.now.to_i
		@day.add_start(time - 100)
		expect(@day.add_stop(time)).to eq(time)
	end

	it 'should be equal to other day with the same data' do
		first_day = Day.new(tasks: ["emails"])
		second_day = Day.new(tasks: ["emails"])
		expect(first_day).to eq(second_day)
	end

	it 'should have a method that returns last start time' do
		time = Time.now.to_i
		@day.add_start(time)
		expect(@day.last_start).to eq(time)
	end

	it 'should have a method that returns last stop time' do
		time = Time.now.to_i
		@day.add_start(time - 500)
		@day.add_stop(time)
		expect(@day.last_stop).to eq(time)
	end

	it 'should raise an ArgumentError if passed stop time is lower than last start time' do
		time = Time.now.to_i
		@day.add_start(time)		
		expect { @day.add_stop(time - 300) }.to raise_error(ArgumentError)
	end

	it 'should raise an ArgumentError if passed start time is lower than last start time' do
		time = Time.now.to_i
		@day.add_start(time)		
		@day.add_stop(time + 600)
		expect { @day.add_start(time - 500) }.to raise_error(ArgumentError)
	end

	it 'should raise an ArgumentError if passed start time is lower than last stop time' do
		time = Time.now.to_i
		@day.add_start(time)
		@day.add_stop(time + 1000)
		expect { @day.add_start(time + 500) }.to raise_error(ArgumentError)
	end

	def duration(hours, minutes, seconds)
		hours * 60 * 60 + minutes * 60 + seconds
	end
end