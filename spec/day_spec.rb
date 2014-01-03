require 'date'
require 'timecop'

require_relative '../lib/timert/day'

describe Timert::Day do
  let(:now) { Time.now.to_i}
  let(:day) { Timert::Day.new }

  it 'should have method intervals that returns array' do
    expect(day.intervals.instance_of?(Array)).to eq(true)
  end

  context 'containing a completed, 100 seconds interval' do
    before do
      day.add_start(now)
      day.add_stop(now + 100)
    end

    it 'should have a method intervals that returns an array with start and stop times' do
      expect(day.intervals).to eq([{"start" => now, "stop" => now + 100}])
    end

    it 'should have a method that returns total elapsed time' do
      expect(day.total_elapsed_time).to eq(100)
    end

    it 'should have a method that returns a hash representation of the object' do
      expect(day.to_hash).to eq({
        "intervals" => [{"start" => now, "stop" => now + 100}],
        "tasks" => []})
    end

    it 'should have a method that says that no interval is started' do
      expect(day.is_interval_started?).to eq(false)
    end

    it 'should have a method that returns the time of the last start' do
      expect(day.last_start).to eq(now)
    end

    it 'should have a method that returns the time of the last stop' do
      expect(day.last_stop).to eq(now + 100)
    end

    it "should not add a new interval when no interval is started" do
      expect { day.add_stop(now + 200) }.to_not change(day, :intervals)
    end
  end

  it "should not add a new interval when the last one hasn't been completed" do
    day.add_start(now)
    expect { day.add_start(now) }.not_to change(day, :intervals)
  end

  it 'should have a method that returns total elapsed time' do
    day.add_start(Time.new(2013, 6, 10, 12, 34).to_i)
    day.add_stop(Time.new(2013, 6, 10, 14, 51, 10).to_i)
    day.add_start(Time.new(2013, 6, 10, 16, 10, 20).to_i)
    day.add_stop(Time.new(2013, 6, 10, 17, 15, 41).to_i)
    expect(day.total_elapsed_time).to eq(duration(3, 22, 31))
  end

  context "when calculating total elapsed time and when last interval isn't finished" do
    let(:now) { Time.new(2013, 6, 10, 18, 10) }

    context 'and the day is today' do
      let(:start_of_work) { Time.new(2013, 6, 10, 12, 0) }

      it "should assume the interval's end to now" do
        Timecop.freeze(now) do
          day.add_start(start_of_work.to_i)
           # It is 6h and 10min between work started at 12:00 and now (18:10).
          expect(day.total_elapsed_time).to eq(duration(6, 10, 0))
        end
      end
    end

    context "and the day is yesterday" do
      let(:start_of_work) { Time.new(2013, 6, 9, 13, 30) }

      it "should assume the interval's end to the last second of yesteday" do
        day.add_start(start_of_work.to_i)
        Timecop.freeze(now) do
          # It is 10h and 30min between work started at 13:30 and end of the day.
          expect(day.total_elapsed_time).to eq(duration(10, 30, 0))
        end
      end

      context "and yesterday was the last day of the year" do
        let(:new_years_eve) { Time.new(2013, 12, 31, 12, 30) }
        let(:new_year) { Time.new(2014, 1, 1, 11, 0) }

        it "should not raise an error" do
          day.add_start(new_years_eve.to_i)
          Timecop.freeze(new_year) do
            expect{ day.total_elapsed_time }.not_to raise_error
          end
        end
      end
    end
  end

  it 'should have tasks method that returns an array' do
    expect(day.tasks.instance_of?(Array)).to eq(true)
  end

  it 'should add tasks' do
    day.add_task("watching youtube")
    day.add_task("walking the dog")
    expect(day.tasks).to eq(["watching youtube", "walking the dog"])
  end

  context 'after initialized with hash data' do
    let(:valid_params) do
      {
        intervals: [{"start" => now, "stop" => now + 300}],
        tasks: ["debugging", "emails"],
        date: Time.now.to_date
      }
    end

    let(:day) { Timert::Day.new(valid_params) }

    it "should raise error if tasks aren't an array" do
      expect { Timert::Day.new(valid_params.merge(tasks: "mails")) }.to raise_error
    end

    it "should raise error if intervals aren't an array" do
      expect { Timert::Day.new(valid_params.merge(intervals: {"start" => 0})) }.to raise_error
    end

    it 'should have a method intervals that returns array with start and stop times' do
      expect(day.intervals).to eq([{"start" => now, "stop" => now + 300}])
    end

    it 'should have a method tasks that returns an array of tasks' do
      expect(day.tasks).to eq(["debugging", "emails"])
    end

    it "should have a method that returns the day's date" do
      expect(day.date).to eq(Time.now.to_date)
    end

    it "should have to_hash method that returns day's state" do
      hash = {
        "intervals" => [{"start" => now, "stop" => now + 300}],
        "tasks" => ["debugging", "emails"]
      }
      expect(day.to_hash).to eq(hash)
    end
  end

  it "should return start time when it's added" do
    expect(day.add_start(now)).to eq(now)
  end

  it "should return stop time when it's added" do
    day.add_start(now - 100)
    expect(day.add_stop(now)).to eq(now)
  end

  it 'should be equal to other day with the same data' do
    first_day = Timert::Day.new(tasks: ["emails"])
    second_day = Timert::Day.new(tasks: ["emails"])
    expect(first_day).to eq(second_day)
  end

  it 'should raise an ArgumentError if passed stop time is lower than last start time' do
    day.add_start(now)
    expect { day.add_stop(now - 300) }.to raise_error(ArgumentError)
  end

  it 'should raise an ArgumentError if passed start time is lower than last start time' do
    day.add_start(now)
    day.add_stop(now + 600)
    expect { day.add_start(now - 500) }.to raise_error(ArgumentError)
  end

  it 'should raise an ArgumentError if passed start time is equal to last start time' do
    day.add_start(now)
    day.add_stop(now + 600)
    expect { day.add_start(now) }.to raise_error(ArgumentError)
  end

  it 'should raise an ArgumentError if passed start time is lower than last stop time' do
    day.add_start(now)
    day.add_stop(now + 1000)
    expect { day.add_start(now + 500) }.to raise_error(ArgumentError)
  end

  it 'should not raise an ArgumentError if passed start time is equal to last stop time' do
    day.add_start(now)
    day.add_stop(now + 1000)
    expect { day.add_start(now + 1000) }.not_to raise_error
  end

  context "when it's initialized with date" do
    let(:day) { Timert::Day.new(date: Date.new(2013, 5, 12)) }
    before do
      Timecop.freeze(Time.new(2013, 5, 12, 12, 30))
    end

    after do
      Timecop.return
    end

    it "should raise error if a start time with a different date is added" do
      expect { day.add_start(Time.new(2013, 6, 14, 12).to_i) }.to raise_error
    end

    it "should raise error if a stop time with a different date is added" do
      day.add_start(now)
      expect { day.add_stop(Time.new(2013, 6, 14, 12).to_i) }.to raise_error
    end
  end

  context "when a task is added more than once" do
    before do
      day.add_task("mails")
      day.add_task("mails")
    end

    it "should ignore it" do
      expect(day.to_hash).to eq({"tasks" => ["mails"], "intervals" => []})
    end
  end

  def duration(hours, minutes, seconds)
    hours * 60 * 60 + minutes * 60 + seconds
  end
end