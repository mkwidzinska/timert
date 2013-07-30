require 'json'
require 'timecop'
require_relative '../lib/timert/timer'
require_relative '../lib/timert/day'

describe Timert::Timer do
  before(:each) do
    @today = Timert::Day.new
    @timer = Timert::Timer.new(@today)
  end  

  it 'should return start time when started' do    
    Timecop.freeze(Time.new(2013, 2, 14, 22, 0)) do
      expect(@timer.start[:time]).to eq(Time.now.to_i)
    end
  end

  context 'while running' do
    before do
      Timecop.freeze(Time.new(2013, 2, 14, 22, 0))
      @timer.start
    end

    after do
      Timecop.return
    end

    it "should not start again until it's stopped" do
      time = Time.now.to_i
      expect(@timer.start(time)[:started]).not_to eq(true)
      expect(@timer.start(time + 10)[:started]).not_to eq(true)
      @timer.stop
      expect(@timer.start(time + 10)[:started]).to eq(true)
    end    

    context 'and then stopped' do
      it 'should return stop time' do    
        Timecop.freeze(Time.new(2013, 2, 14, 23, 0)) do
          expect(@timer.stop[:time]).to eq(Time.now.to_i)      
        end
      end
    end
  end  

  context 'while not running' do
    it "should not stop until it's started" do
      expect(@timer.stop[:stopped]).not_to eq(true)
      @timer.start
      expect(@timer.stop[:stopped]).to eq(true)
    end
  end  

  it 'should be able to start with given time' do
    time = Time.now.to_i
    expect(@timer.start(time)[:time]).to eq(time)
  end

  it 'should be able to stop with given time' do
    @timer.start
    time = Time.now.to_i + 500
    expect(@timer.stop(time)[:time]).to eq(time)
  end
end