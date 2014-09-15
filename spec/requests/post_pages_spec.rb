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

  describe "visiting existing post" do
    let(:have_hit_counter) do
      have_selector("#hits_post_#{@post.id}")
    end

    before do
      @post = create(:post)
    end

    describe "as new visitor" do
      it "should increment hit counter and impressions" do
        expect { visit post_path(@post) }.to change(Hit, :count).by(1)
        expect(Hit.last.impressions).to eq 1
      end
    end
    describe "when re-visiting" do
      before do
        visit post_path(@post)
      end
      it "should increment impressions but not hits" do
        expect { visit post_path(@post) }.to change(Hit, :count).by(0)
        expect(Hit.last.impressions).to eq 2
      end
    end

    describe "as admin" do
      before do
        sign_in admin
        visit post_path(@post)
      end

      it { should have_hit_counter }

      describe "and clicking hit counter" do
        let!(:other_hit) { create(:hit) }
        before do
          find("#hits_post_#{@post.id} a").click
        end

        it "should browse to embedded resource" do
          expect(current_path).to eq post_hits_path(@post)
        end

        it { should_not have_selector("#hit_#{other_hit.id}") }
        it { should have_selector("#hit_#{@post.reload.hits.first.id}") }
      end
    end

    describe "as anonymous" do
      before do
        visit post_path(@post)
      end

      it { should_not have_hit_counter }
    end

    describe "as author" do
      before do
        sign_in @post.user
        visit post_path(@post)
      end

      it { should have_hit_counter }
    end

    describe "as user but not author or admin" do
      before do
        sign_in create(:user)
        visit post_path(@post)
      end

      it { should_not have_hit_counter }
    end
  end

end
