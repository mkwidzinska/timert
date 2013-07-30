require 'timecop'

require_relative '../lib/day'

describe Day do
  before(:each) do
    @day = Day.new
  end

  def now
    Time.now.to_i
  end
  
  it 'should have method intervals that returns array' do
    expect(@day.intervals.instance_of?(Array)).to eq(true)
  end

  context 'containing a 100 seconds interval' do
    before  do
      @day.add_start(now)
      @day.add_stop(now + 100)
    end

    it 'should have a method intervals that contains hash with start and stop times' do
      expect(@day.intervals).to eq([{"start" => now, "stop" => now + 100}])      
    end

    it 'should have a method that returns total elapsed time' do
      expect(@day.total_elapsed_time).to eq(100)
    end

    it 'should have a method that returns a hash representation of the object' do
      expect(@day.to_hash).to eq({
        "intervals" => [{"start" => now, "stop" => now + 100}],
        "tasks" => []})
    end

    it 'should have a method that says that no interval is started' do
      expect(@day.is_interval_started?).to eq(false)
    end

    it 'should have a method that returns the time of the last start' do
      expect(@day.last_start).to eq(now)      
    end

    it 'should have a method that returns the time of the last start' do
      expect(@day.last_stop).to eq(now + 100)
    end
  end

  it "should not add a new interval when the last one hasn't been completed" do
    time = now
    @day.add_start(time)
    expect(@day.intervals.length).to eq(1)
    @day.add_start(time)
    expect(@day.intervals.length).to eq(1)
  end

  it "should not add stop time when no interval is started" do
    time = now
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

  context "when calculating total elapsed time and when last interval isn't finished" do
    before do
      Timecop.freeze(Time.new(2013, 6, 10, 18, 10, 20)) do
        @day.add_start(Time.new(2013, 6, 10, 12, 34).to_i)
        @day.add_stop(Time.new(2013, 6, 10, 14, 51, 10).to_i)
        @day.add_start(Time.new(2013, 6, 10, 16, 10, 20).to_i)    
        expect(@day.total_elapsed_time).to eq(duration(4, 17, 10))
      end
    end

    context 'and the day is today' do
      it "should assume the interval's end to now" do
        Timecop.freeze(Time.new(2013, 6, 10, 18, 10, 20)) do
          expect(@day.total_elapsed_time).to eq(duration(4, 17, 10))
        end
      end
    end

    context "and the day is yesterday" do
      it "should assume the interval's end to the last second of yesteday" do
        Timecop.freeze(Time.new(2013, 6, 11, 18, 10, 20)) do
          expect(@day.total_elapsed_time).to eq(duration(10, 6, 49))
        end
      end
    end
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
        intervals: [{"start" => now, "stop" => now + 300}],
        tasks: ["debugging", "emails"]
      )      
    end

    it 'should contain appropiate data' do
      expect(@day.intervals.last["start"]).to eq(now)
      expect(@day.intervals.last["stop"]).to eq(now + 300)
      expect(@day.tasks).to eq(["debugging", "emails"])      
      expect(@day.date).to eq(Time.now.to_date)      
    end

    it "should have to_hash method that returns day's state" do
      hash = {
        "intervals" => [{"start" => now, "stop" => now + 300}],
        "tasks" => ["debugging", "emails"]        
      }
      expect(@day.to_hash).to eq(hash)  
    end
  end

  it "should return start time when it's added" do
    time = now
    expect(@day.add_start(time)).to eq(time)
  end

  it "should return stop time when it's added" do
    time = now
    @day.add_start(time - 100)
    expect(@day.add_stop(time)).to eq(time)
  end

  it 'should be equal to other day with the same data' do
    first_day = Day.new(tasks: ["emails"])
    second_day = Day.new(tasks: ["emails"])
    expect(first_day).to eq(second_day)
  end

  it 'should have a method that returns last start time' do
    time = now
    @day.add_start(time)
    expect(@day.last_start).to eq(time)
  end

  it 'should have a method that returns last stop time' do
    time = now
    @day.add_start(time - 500)
    @day.add_stop(time)
    expect(@day.last_stop).to eq(time)
  end

  it 'should raise an ArgumentError if passed stop time is lower than last start time' do
    time = now
    @day.add_start(time)    
    expect { @day.add_stop(time - 300) }.to raise_error(ArgumentError)
  end

  it 'should raise an ArgumentError if passed start time is lower than last start time' do
    time = now
    @day.add_start(time)    
    @day.add_stop(time + 600)
    expect { @day.add_start(time - 500) }.to raise_error(ArgumentError)
  end

  it 'should raise an ArgumentError if passed start time is equal to last start time' do
    time = now
    @day.add_start(time)    
    @day.add_stop(time + 600)
    expect { @day.add_start(time) }.to raise_error(ArgumentError)
  end

  it 'should raise an ArgumentError if passed start time is lower than last stop time' do
    time = now
    @day.add_start(time)
    @day.add_stop(time + 1000)
    expect { @day.add_start(time + 500) }.to raise_error(ArgumentError)
  end

  it 'should not raise an ArgumentError if passed start time is equal to last stop time' do
    time = now
    @day.add_start(time)
    @day.add_stop(time + 1000)
    expect { @day.add_start(time + 1000) }.not_to raise_error()
  end

  context 'when one start time and no stop time has been added' do
    before do
      Timecop.freeze(Time.new(2013, 5, 12, 12, 30))
      @day.add_start(now)
    end

    after do
      Timecop.return
    end

    it "should set a date to the start time's date" do
      expect(@day.date).to eq(Date.new(2013, 5, 12))      
    end

    it "should raise error if a stop time with a different date is added" do
      expect { @day.add_stop(Time.new(2013, 6, 14, 12).to_i) }.to raise_error
    end
  end

  def duration(hours, minutes, seconds)
    hours * 60 * 60 + minutes * 60 + seconds
  end
end