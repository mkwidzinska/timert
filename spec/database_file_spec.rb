require_relative '../lib/database_file'

describe DatabaseFile do
  let(:path) { './spec/data/timert' }

  before(:each) do
    @file = DatabaseFile.new(path)
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