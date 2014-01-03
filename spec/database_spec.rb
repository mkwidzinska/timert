require 'timecop'
require 'date'

require_relative '../lib/timert/database'
require_relative '../lib/timert/database_file'
require_relative '../lib/timert/day'

describe Timert::Database do
  before(:each) do
    @path = "./spec/data/test_data"
    @db = Timert::Database.new(Timert::DatabaseFile.new(@path))
  end

  after(:each) do
    File.delete(@path)
  end

  it 'should have a method for getting the current day' do
    write_day = Timert::Day.new(tasks: ["emails"])
    @db.save(write_day)
    read_day = @db.day
    expect(write_day.to_hash).to eq(read_day.to_hash)
  end

  it 'should have a method for getting one of the past days' do
    write_day = Timecop.freeze(Time.new(2013, 8, 12, 12)) do
      @db.save(Timert::Day.new(tasks: ["meeting"]))
      @db.day
    end
    read_day = Timecop.freeze(Time.new(2013, 8, 14, 12)) do
      @db.day(Date.today - 2)
    end
    expect(write_day).to eq(read_day)
  end

  it 'should save current day' do
    day = Timert::Day.new(tasks: ["emails", "reading"])
    @db.save(day)
    expect(@db.day).to eq(day)
  end

  it 'should have a method for getting a range of days' do
    first = Timert::Day.new(tasks: ["emails"], date: Date.new(2013, 9, 10))
    second = Timert::Day.new(tasks: ["meetings"], date: Date.new(2013, 9, 11))

    past = Timecop.freeze(first.date) do
      @db.save(first)
      Date.today - 5
    end

    present = Timecop.freeze(second.date) do
      @db.save(second)
      Date.today
    end

    expect(@db.days(Range.new(past, present))).to eq([first, second])
  end
end