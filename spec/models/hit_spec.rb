require 'spec_helper'

describe Hit do
  before { @hit = build(:hit) }

  subject { @hit }

  it { should be_valid }

  %i(ip_address hittable).each do |field|
    describe "without #{field}" do
      before { @hit.send("#{field}=", nil) }
      it { should_not be_valid }
    end
  end

  describe "impressions" do
    subject { @hit.impressions }
    describe "by default" do
      it { should eq 0 }
    end
    describe "if set" do
      before do
        @hit.impressions = 1
        @hit.save
        @hit.reload
      end

      it { should eq 1 }
    end
  end
end
