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
  it {should respond_to(:embed_code)}
  
  describe "When title is empty" do
    before {@post.title=''}
    it {should_not be_valid}
  end
  
end
