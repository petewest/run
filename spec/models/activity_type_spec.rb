require 'spec_helper'

describe ActivityType do
  before do
    @activity_type=ActivityType.new(name: "Run", identifier: "run")
  end
  subject { @activity_type }
  it { should be_valid }
  describe "When name is blank" do
    before { @activity_type.name="" }
    it { should_not be_valid }
  end
end
