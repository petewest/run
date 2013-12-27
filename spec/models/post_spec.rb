require 'spec_helper'

describe Post do
  before do
    @user = FactoryGirl.create(:user)
    @category = FactoryGirl.create(:category)
    @post = FactoryGirl.create(:post, user: @user, category: @category)
  end
  
  subject {@post}
  
  it {should be_valid}
  it {should respond_to(:title)}
  it {should respond_to(:write_up)}
  it {should respond_to(:stub)}
  
  describe "When title is empty" do
    before {@post.title=''}
    it {should_not be_valid}
  end
  
  describe "stub" do
    before {@post.save}
    subject {@post.stub}
    it {should_not be_empty}
    it {should eq @post.title.parameterize}
    describe "after changing title" do
      let!(:old_stub) {@post.stub}
      before do
        @post.title="New title"
        @post.save
      end
      it {should eq old_stub}
      it {should_not eq @post.title.parameterize}
    end
  end
  
end
