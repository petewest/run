require 'spec_helper'

describe Hit do
  before { @hit = build(:hit) }

  subject { @hit }

  it { should be_valid }
  it { should respond_to(:increment_impressions!) }

  %i(ip_address hittable).each do |field|
    describe "without #{field}" do
      before { @hit.send("#{field}=", nil) }
      it { should_not be_valid }
    end
  end

  describe "with other hits" do
    let!(:reference_hit) { create(:hit) }
    %i(ip_address).each do |field|
      describe "and #{field}s match" do
        before { @hit.send("#{field}=", reference_hit.send(field)) }
        it { should be_valid }

        describe "when hittable matches" do
          before { reference_hit.update_attributes(hittable: @hit.hittable) }
          it { should_not be_valid }
        end
      end
    end
  end

  describe "impressions" do
    subject { @hit.impressions }
    describe "by default" do
      it { should eq 0 }
    end
    describe "when incremented" do
      before do
        @hit.increment_impressions!
        @hit.reload
      end

      it { should eq 1 }
    end
  end
end
