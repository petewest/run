require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    subject { page }
    before { visit root_path }

    it {should have_title('Run') }
    it {should have_content('Run') }
  end
  
  describe "About page" do
    
    subject { page }
    before { visit about_path }
    
    it { should have_title('About')}
    it { should have_content('About') }
  end
end
