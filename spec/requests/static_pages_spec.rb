require 'spec_helper'

describe "Static pages" do

  describe "About page" do

    subject { page }
    before { visit about_path }

    it {should have_title('Run') }
    it {should have_content('Run') }
  end
end
