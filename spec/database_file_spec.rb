require_relative '../lib/timert/database_file'

describe Timert::DatabaseFile do
  let(:path) { './spec/data/timert' }

  before(:each) do
    @file = Timert::DatabaseFile.new(path)
  end

  after(:each) do
    File.delete(path)
  end
  
  it "should load data that's been saved" do
    data = {
      "example" => "This is a sample data."
    }
    @file.save(data)
    expect(@file.load).to eq(data)
  end
end