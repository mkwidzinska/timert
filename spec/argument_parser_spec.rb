require 'timecop'
require_relative '../lib/timert/argument_parser'

describe Timert::ArgumentParser do
  let(:ap_with_empty_array) { Timert::ArgumentParser.new([]) }
  let(:ap_with_start) { Timert::ArgumentParser.new(['start']) }
  let(:ap_with_start_at) { Timert::ArgumentParser.new(['start', '16:50']) }
  let(:ap_with_stop_at) { Timert::ArgumentParser.new(['stop', '19']) }

  it 'should be initialized with one array argument' do
    expect { ap_with_empty_array }.to_not raise_error
  end

  it 'should have action method' do
    expect(ap_with_start.action).to eq('start')
  end

  context 'when a time argument is given with the start action' do
    it 'should have argument method that returns numeric representation of that time' do
      Timecop.freeze(Time.new(2013, 4, 6, 16, 50)) do
        expect(ap_with_start_at.argument).to eq(Time.now.to_i)
      end
    end
  end

  context 'when a time argument is given with the stop action' do
    it 'should have argument method that returns numeric representation of that time' do
      Timecop.freeze(Time.new(2013, 4, 6, 19)) do
        expect(ap_with_stop_at.argument).to eq(Time.now.to_i)
      end
    end
  end

  it 'should have argument equal to nil if one-element array is passed' do
    expect(ap_with_start.argument).to eq(nil)
  end

  it 'should have action equal to help and argument equal to nil if empty array is passed' do
    expect(ap_with_empty_array.action).to eq("help")
    expect(ap_with_empty_array.argument).to eq(nil)
  end

  it 'should have add_task action when no-api argument is passed' do
    expect(Timert::ArgumentParser.new(['buy bananas']).action).to eq('add_task')
    expect(Timert::ArgumentParser.new(['buy bananas']).argument).to eq('buy bananas')
  end
end
