require_relative '../lib/date_formatter'

describe DateFormatter do
  it 'should return formatted hour'  do
    time = Time.new(2000, 1, 1, 14, 20, 13)
    expect(DateFormatter.parse_hour(time.to_i)).to eq(time.to_s.split[1])
  end

  it 'should return formatted date' do
    today = Time.now
    expect(DateFormatter.parse_relative_date).to eq(today.to_s.split[0])
  end
  #rozdzielic
  it 'should return relative formatted date' do
    time = Time.new(2013, 4, 14, 4)
    yesterday = DateFormatter.parse_relative_date(-10, time)
    expect(yesterday).to eq("2013-04-04")

    time = Time.new(2013, 4, 1, 4)
    yesterday = DateFormatter.parse_relative_date(-1, time)
    expect(yesterday).to eq("2013-03-31")

    time = Time.new(2013, 4, 1)
    yesterday = DateFormatter.parse_relative_date(-1, time)
    expect(yesterday).to eq("2013-03-31")
  end

  it 'should return formatted total elapsed time' do
    time = 5 * 60 * 60 + 45 * 60 + 5
    expect(DateFormatter.parse_elapsed_time(time)).to eq("5h 45min 5sec")    

    time = 15 * 60 * 60 + 56
    expect(DateFormatter.parse_elapsed_time(time)).to eq("15h 0min 56sec")    
  end

  it 'should have a method that returns rounded, decimal duration' do
    d = duration(5, 13, 12)
    expect(DateFormatter.round_duration(d)).to eq("5.5")
  end

  def duration(hours, minutes, seconds)
    hours * 60 * 60 + minutes * 60 + seconds
  end
end