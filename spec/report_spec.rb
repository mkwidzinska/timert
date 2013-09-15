require 'timecop'

require_relative '../lib/timert/report'

describe Timert::Report do
  let(:wednesday) { Date.new(2013, 2, 20) }
  let(:tuesday) { Date.new(2013, 2, 19) }
  let(:database) { double }

  let(:first_day) do
    double(total_elapsed_time: 3.5 * 3600, 
      date: wednesday,
      tasks: ["emails", "meeting"],
      intervals: [
        {"start" => time(wednesday, 16), "stop" => time(wednesday, 18, 30)},
        {"start" => time(wednesday, 19), "stop" => time(wednesday, 20)}
      ])
  end

  let(:second_day) do
    double(total_elapsed_time: 7 * 3600, 
      date: tuesday,
      tasks: ["reports", "bugs"],
      intervals: [
        {"start" => time(tuesday, 11, 30), "stop" => time(tuesday, 16)},
        {"start" => time(tuesday, 16, 30), "stop" => time(tuesday, 19, 30)}
      ])
  end

  before(:each) do
    Timecop.freeze(wednesday)
  end

  after(:each) do
    Timecop.return    
  end

  it 'should generate report for wednesday' do
    database.should_receive(:day).with(wednesday).and_return(first_day)
    
    report = Timert::Report.generate(database)
    expect(report.include?("2013-02-20")).to eq(true)
    expect(report.include?("emails")).to eq(true)
    expect(report.include?("meeting")).to eq(true)
    expect(report.include?("3.5")).to eq(true)
  end

  it 'should generate report for any past day' do    
    database.should_receive(:day).with(tuesday).and_return(second_day)

    report = Timert::Report.generate(database, -1)
    expect(report.include?("2013-02-19")).to eq(true)
    expect(report.include?("reports")).to eq(true)
    expect(report.include?("bugs")).to eq(true)
    expect(report.include?("7")).to eq(true)
  end

  it 'should generate report for this week' do
    database.should_receive(:days).and_return([first_day, second_day])

    report = Timert::Report.generate(database, "week")
    expect(report.include?("WEEK")).to eq(true)
    expect(report.include?("2013-02-19")).to eq(true)
    expect(report.include?("2013-02-20")).to eq(true)
    expect(report.include?("Total")).to eq(true)
    expect(report.include?("10.5")).to eq(true)
  end

  it 'should generate report for this month' do
    database.should_receive(:days).and_return([first_day, second_day])

    report = Timert::Report.generate(database, "month")
    expect(report.include?("MONTH")).to eq(true)
    expect(report.include?("2013-02-19")).to eq(true)
    expect(report.include?("2013-02-20")).to eq(true)
    expect(report.include?("Total")).to eq(true)
    expect(report.include?("10.5")).to eq(true)
  end

  def time(day, hours, minutes = 0, seconds = 0)
    day.to_time.to_i + hours * 3600 + minutes * 60 + seconds
  end
end
