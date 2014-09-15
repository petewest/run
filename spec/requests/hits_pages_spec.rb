require 'spec_helper'

describe "Hits" do
  let!(:hit) { create(:hit, impressions: 3) }
  let(:redirected_to_root?) do
    should have_title("Runs")
    expect(current_path).to eq(root_path)
  end

  subject { page }
  describe "as anonymous" do
    before do
      visit hits_path
    end

    it "should redirect to root" do
      redirected_to_root?
    end
  end

  describe "when signed in as non-admin" do
    before do
      sign_in(create(:user))
      visit hits_path
    end

    it "should redirect to root" do
      redirected_to_root?
    end
  end

  describe "when signed in as admin" do
    before do
      sign_in(create(:admin))
      visit hits_path
    end

    it { should have_title("Hits") }
    it { should have_selector("#hit_#{hit.id}") }
    it { should have_selector("#hittable_hit_#{hit.id}", text: hit.hittable.title) }
    it { should have_selector("#ip_hit_#{hit.id}", text: hit.ip_address) }
    it { should have_selector("#impressions_hit_#{hit.id}", text: hit.impressions.to_s) }
    it { should have_link(hit.hittable.title, href: post_path(hit.hittable)) }
  end

end