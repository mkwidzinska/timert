require_relative '../lib/application'

describe Application do
  it 'should be initialized with one array argument' do
    expect { Application.new([]) }.to_not raise_error
  end
end
