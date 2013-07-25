require 'timecop'

require_relative '../lib/report'
require_relative '../lib/database'
require_relative '../lib/day'

describe Report do
  let(:path) { './spec/data/timert' }
  let(:database) { 
    db = Database.new(path)     
    Timecop.freeze(Time.new(2013, 2, 20, 19)) do
      db.save_today(sample_day)
    end
    Timecop.freeze(Time.new(2013, 2, 19, 19)) do
      db.save_today(sample_day)
    end
    db
  }

  def sample_day
    day = Day.new
    day.add_start(Time.new(2013, 2, 20, 14, 00).to_i)
    day.add_stop(Time.new(2013, 2, 20, 15, 13).to_i)
    day.add_start(Time.new(2013, 2, 20, 16, 4, 24).to_i)
    day.add_stop(Time.new(2013, 2, 20, 18, 45).to_i)
    day.add_task("emails")
    day.add_task("meeting")
    day
  end

  before(:each) do
    database
    Timecop.freeze(Time.new(2013, 2, 20))
  end

  after(:each) do
    Timecop.return
    File.delete(path)
  end

  it 'should generate report for today' do
    expect(Report.generate(database).instance_of?(String)).to eq(true)
  end

  it 'should generate report for any past day' do
    expect(Report.generate(database, -1).instance_of?(String)).to eq(true)
  end

  it 'should generate report for this week' do
    expect(Report.generate(database, "week").instance_of?(String)).to eq(true)
  end

  it 'should generate report for this month' do
    expect(Report.generate(database, "month").instance_of?(String)).to eq(true)
  end
end