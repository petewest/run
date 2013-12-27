require 'spec_helper'

describe "Post pages" do
  let(:admin) { FactoryGirl.create(:admin) }
  let(:category) {FactoryGirl.create(:category) }
  subject { page }

  describe "new page" do
    before do 
      sign_in(admin)
      category.save
      visit new_post_path
    end
    it {should have_title('New post')}

    let(:submit) { "Create Post" }

    describe "with invalid information" do
      it "should not create a category" do
        expect { click_button submit }.not_to change(Post, :count)
      end
    end
    describe "with valid information" do
      before do
        fill_in "Title",         with: "Race 1"
        select category.name, from: "Category"
        fill_in "write_up_input", with: "Woohoo, what a run!"
      end

      it "should create a post" do
        expect { click_button submit }.to change(Post, :count).by(1)
      end
      describe "after saving the post" do
        before { click_button submit }
        let(:post) { Post.find_by_title("Race 1") }

        it { should have_title(post.title) }
        it { should have_selector('div.alert.alert-success', text: 'Post created!') }
      end
    end
  end

end
