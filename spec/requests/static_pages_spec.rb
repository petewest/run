require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    subject { page }
    before { visit root_path }

    it {should have_title('Run') }
    it {should have_content('Run') }
    it {should have_link('About', href: about_path) }
    it {should have_link('', href: root_url) }
    it { should_not have_link('Hits', href: hits_path) }

    describe "when admin" do
      before do
        sign_in(create(:admin))
        visit root_path
      end

      it { should have_link('Hits', href: hits_path) }
    end
  end
  
  describe "About page" do
    
    subject { page }
    before { visit about_path }
    
    it { should have_title('About')}
    it { should have_content('About') }
    it {should have_link('', href: root_url) }
  end
end
