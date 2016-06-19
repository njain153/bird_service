require 'spec_helper'

RSpec.describe "Bird Model" do
	before(:all) do
		@bird_id = "212"
		@body = JSON.parse('{"name":"bird3","family":"pigeon","continents":["aisa","africa"]}')
	end

	describe "birds" do

		it "should add bird" do
			bird = Bird.new
			expect{bird.save(@bird_id, @body)}.not_to raise_exception
			bird.find(@bird_id).should_not be_nil
		end

		it "should get bird successfully" do
			bird = Bird.new
			expect{bird.save(@bird_id, @body)}.not_to raise_exception
			bird.find(@bird_id)['_id'].should == @bird_id
		end

		it "should return nil if no bird with id exists" do
			bird = Bird.new
			bird.find(@bird_id).should be_nil
		end

		it "should add date if not already present" do
			date = Time.new
			today = date.year.to_s  + "/" + date.month.to_s + "/" + date.day.to_s
			bird = Bird.new
			expect{bird.save(@bird_id, @body)}.not_to raise_exception
			bird.find(@bird_id)['added'].should == today
		end

		it "should get list of visible birds" do
			bird = Bird.new
			bird.save(@bird_id, @body)
			bird.save("213", @body.dup.merge(visible: false))
			bird.save("214", @body.dup.merge(visible: true))
			bird.findAll == ["212","214"]
		end

		it "should remove bird successfully" do
			bird = Bird.new
			bird.save(@bird_id, @body)
			bird.find(@bird_id).should_not be_nil
			bird.remove(@bird_id).should == true
			bird.find(@bird_id).should be_nil
		end

		it "should not remove and return false if there are is no bird to remove" do
			bird = Bird.new
			bird.remove(@bird_id).should == false
		end

		it "should throw ResourceExists if trying to add the same bird again" do
			bird = Bird.new
			bird.save(@bird_id, @body)
			expect{bird.save(@bird_id, @body)}.to raise_exception ResourceExistsError
		end

		it "should do maximum 3 retry if there is monog connection error" do
			bird = Bird.new
			collection = double("collection", remove: nil)
			Bird.stub(:collection).and_return(collection)
			#collection.stub(:)
			collection.stub(:insert).and_raise(::Mongo::ConnectionFailure)
			Kernel.should_receive(:sleep).exactly(3).times
			expect{bird.save(@bird_id, @body)}.to raise_exception ::Mongo::ConnectionFailure
		end

		after(:each) do
			Bird.collection.remove
		end

	end

end