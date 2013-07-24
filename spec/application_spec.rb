require 'timecop'
require_relative '../lib/application'

describe Application do
	let(:path) { './spec/data/timert' }
	let(:database) { Database.new(path) }
	let(:app_with_no_args) { Application.new([], path) }
	
	after(:each) do
		File.delete(path)
	end

	context 'when initialized with empty arguments' do
		before do
		end

		it 'should be initialized without errors' do
		  expect { app_with_no_args }.to_not raise_error
		end
	end

	context 'when initialized with start argument' do
		before do
			Timecop.freeze(Time.new(2013, 6, 12, 13, 56))
			@app = Application.new(["start"], path)			
		end

		after do
			Timecop.return
		end
  	
  	it 'should perform start operation' do
  		expect(database.today.last_start).to eq(Time.now.to_i)
		end

		it 'should have a method that returns hash result' do
			expect(@app.result.instance_of?(Hash)).to eq(true)
		end

		context 'and then initialized with stop argument' do
			before do
				Timecop.freeze(Time.new(2013, 6, 12, 14, 34))
				@app = Application.new(["stop"], path)			
			end

			after do
				Timecop.return
			end
	  	
	  	it 'should perform stop operation' do
	  		expect(database.today.last_stop).to eq(Time.now.to_i)
			end

			it 'should have a method that returns hash result' do
				expect(@app.result.instance_of?(Hash)).to eq(true)
			end
		end
	end

	context 'when initialized with report argument' do
		before do
			@app = Application.new(["start"], path)			
		end

		it 'should have a method that returns hash result' do
			expect(@app.result.instance_of?(Hash)).to eq(true)
		end
	end
end
