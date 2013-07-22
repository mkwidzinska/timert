require_relative '../lib/argument_parser'

describe ArgumentParser do
  let(:ap_with_empty_array) { ArgumentParser.new([]) }
  let(:ap_with_start) { ArgumentParser.new(['start']) }
  let(:ap_with_start_at) { ArgumentParser.new(['start', '16:50']) }

  it 'should be initialized with one array argument' do
    expect { ap_with_empty_array }.to_not raise_error
  end

  it 'should have action method' do
    expect(ap_with_start.action).to eq('start')
  end

  it 'should have argument method' do
    expect(ap_with_start_at.argument).to eq('16:50')
  end

  it 'should have argument equal to nil if one-element array is passed' do
    expect(ap_with_start.argument).to eq(nil)
  end

  it 'should have action and argument equal to nil if empty array is passed' do
    expect(ap_with_empty_array.action).to eq(nil)
    expect(ap_with_empty_array.argument).to eq(nil)
  end

  it 'should have add_task action when no-api argument is passed' do
    expect(ArgumentParser.new(['buy bananas']).action).to eq('add_task')
    expect(ArgumentParser.new(['buy bananas']).argument).to eq('buy bananas')
  end
end
