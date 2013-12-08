require 'spec_helper'

describe Category do
  before do
    @category = Category.new(name: "Race", stub: "race", sort_order: 0)
  end
  
  subject {@category}
  
  it {should be_valid}
  it {should respond_to(:name)}
  it {should respond_to(:stub)}
  it {should respond_to(:sort_order)}
  
  describe "when there's no name" do
    before { @category.name='' }
    it {should_not be_valid}
  end
    
  describe "when the stub is" do
    describe "not present" do
      before { @category.stub='' }
      it {should_not be_valid}
    end
    
    describe "too long" do
      before { @category.stub='a'*21 }
      it {should_not be_valid}
    end
    describe "mixed case" do
      it "should be downcased" do
        new_stub="AaAaaaDsd"
        @category.stub=new_stub
        @category.save!
        expect(@category.stub).to eq new_stub.downcase
      end
    end
    describe "invalid" do
      before { @category.stub="this/that"}
      it {should_not be_valid}
    end
    it "should be unique" do
      @category.save!
      new_category=Category.new(name: "Race2", stub: "race", sort_order: 1)
      expect(new_category).to_not be_valid
    end  
  end


end
