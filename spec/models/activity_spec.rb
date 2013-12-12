require 'spec_helper'

describe Activity do
  before do
    @user = FactoryGirl.create(:user)
    @activity_type = FactoryGirl.create(:activity_type)
    @activity = FactoryGirl.create(:activity, user: @user, activity_type: @activity_type)
  end
  
  subject { @activity }
  describe "with valid data" do
    it {should be_valid}
  end
  
  describe "without a start time" do
    before { @activity.start_time='' }
    it {should_not be_valid}
  end
  
  describe "it should belong to the user" do
    before do
      @user.save!
      @activity_type.save!
      @activity.save!
    end
    specify { expect(@activity.user).to eq(@user) }
  end

end
