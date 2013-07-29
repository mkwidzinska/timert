require_relative '../lib/duration'

describe Duration do
  
  it 'should have a method that returns the number of hours' do
    expect(Duration.new(3 * 60 * 60 + 2 * 60).hours).to eq(3)
  end

  it 'should have a method that returns the number of minutes' do
    expect(Duration.new(3 * 60 * 60 + 2 * 60).minutes).to eq(2)
  end

  it 'should have a method that returns the number of seconds' do
    expect(Duration.new(2 * 60 + 55).seconds).to eq(55)
  end

  it 'should have a method that creates object from given hours, minutes and seconds' do
    expect(Duration.from(2, 5, 10).hours).to eq(2)
  end

end