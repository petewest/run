require 'spec_helper'

describe "Category pages" do
  let(:admin) { FactoryGirl.create(:admin) }
  subject { page }

  describe "new page" do
    before do 
      sign_in(admin)
      visit new_category_path
    end
    it {should have_title('New category')}

    let(:submit) { "Create category" }

    describe "with invalid information" do
      it "should not create a category" do
        expect { click_button submit }.not_to change(Category, :count)
      end
    end
    describe "with valid information" do
      before do
        fill_in "Name",         with: "Race"
        fill_in "Stub",        with: "race"
        fill_in "Sort order",     with: "0"
      end

      it "should create a category" do
        expect { click_button submit }.to change(Category, :count).by(1)
      end
      describe "after saving the category" do
        before { click_button submit }
        let(:category) { Category.find_by_stub("race") }

        it { should have_title(category.name) }
        it { should have_selector('div.alert.alert-success', text: 'New category created') }
      end
    end
  end

end