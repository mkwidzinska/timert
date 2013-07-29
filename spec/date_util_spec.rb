require_relative '../lib/date_util'

describe DateUtil do
  it 'should return formatted hour'  do
    time = Time.new(2000, 1, 1, 14, 20, 13)
    expect(DateUtil.format_hour(time.to_i)).to eq(time.to_s.split[1])
  end

  it 'should return formatted total elapsed time' do
    time = 5 * 60 * 60 + 45 * 60 + 5
    expect(DateUtil.format_elapsed_time(time)).to eq("5h 45min 5sec")    

    time = 15 * 60 * 60 + 56
    expect(DateUtil.format_elapsed_time(time)).to eq("15h 0min 56sec")    
  end

  it 'should have a method that returns rounded, decimal duration' do
    d = duration(5, 13, 12)
    expect(DateUtil.round_duration(d)).to eq("5.5")
  end

  it 'should have a method that returns rounded duration when a full-hour duration is passed' do
    d = duration(4)
    expect(DateUtil.round_duration(d)).to eq("4")
  end

  def duration(hours, minutes = 0, seconds = 0)
    hours * 60 * 60 + minutes * 60 + seconds
  end
end