require_relative '../lib/timert/duration'

describe Timert::Duration do

  it 'should have a method that returns the number of hours' do
    expect(Timert::Duration.new(3 * 60 * 60 + 2 * 60).hours).to eq(3)
  end

  it 'should have a method that returns the number of minutes' do
    expect(Timert::Duration.new(3 * 60 * 60 + 2 * 60).minutes).to eq(2)
  end

  it 'should have a method that returns the number of seconds' do
    expect(Timert::Duration.new(2 * 60 + 55).seconds).to eq(55)
  end

  it 'should have a method that creates new object from given hours, minutes and seconds' do
    expect(Timert::Duration.from(2, 5, 10).hours).to eq(2)
    expect(Timert::Duration.from(2, 5, 10).minutes).to eq(5)
    expect(Timert::Duration.from(2, 5, 10).seconds).to eq(10)
  end

  it 'should return formatted total elapsed time' do
    expect(Timert::Duration.from(5, 45, 5).to_s).to eq("5h 45min 5sec")
    expect(Timert::Duration.from(15, 0, 56).to_s).to eq("15h 0min 56sec")
  end

  it 'should have a method that returns rounded duration when a full-hour duration is passed' do
    expect(Timert::Duration.from(4, 0, 0).round).to eq("4.0")
  end

  it 'should have a method that returns rounded, decimal duration' do
    expect(Timert::Duration.from(5, 13, 12).round).to eq("5.0")
    expect(Timert::Duration.from(5, 15, 12).round).to eq("5.5")
    expect(Timert::Duration.from(5, 35, 12).round).to eq("5.5")
    expect(Timert::Duration.from(5, 46, 12).round).to eq("6.0")
    expect(Timert::Duration.from(5, 59, 12).round).to eq("6.0")
  end

end