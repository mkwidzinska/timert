require 'timecop'
require_relative '../lib/date_util'

describe DateUtil do
  it 'should return formatted hour' do
    time = Time.new(2000, 1, 1, 14, 20, 13)
    expect(DateUtil.format_hour(time.to_i)).to eq(time.to_s.split[1])
  end

  it 'should return formatted date' do
    expect(DateUtil.format_date(Date.new(2013, 3, 14))).to eq("2013-03-14")
  end

  it 'should parse time' do
    Timecop.freeze(Time.new(2013, 2, 28)) do
      expect(DateUtil.parse_time("11:14")).to eq(Time.new(2013, 2, 28, 11, 14).to_i)
    end
  end
end