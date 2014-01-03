require 'timecop'
require_relative '../lib/timert/date_util'

describe Timert::DateUtil do
  it 'should return formatted hour' do
    time = Time.new(2000, 1, 1, 14, 20, 13)
    expect(Timert::DateUtil.format_hour(time.to_i)).to eq(time.to_s.split[1])
  end

  it 'should return formatted date' do
    expect(Timert::DateUtil.format_date(Date.new(2013, 3, 14))).to eq("2013-03-14")
  end

  it 'should return formatted month' do
    expect(Timert::DateUtil.format_month(Date.new(2013, 1, 22))).to eq("2013-01")
  end

  it 'should parse time' do
    Timecop.freeze(Time.new(2013, 2, 28)) do
      expect(Timert::DateUtil.parse_time("11:14")).to eq(Time.new(2013, 2, 28, 11, 14).to_i)
    end
  end
end