require_relative '../lib/date_util'

describe DateUtil do
  it 'should return formatted hour' do
    time = Time.new(2000, 1, 1, 14, 20, 13)
    expect(DateUtil.format_hour(time.to_i)).to eq(time.to_s.split[1])
  end
end