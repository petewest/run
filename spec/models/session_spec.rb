require 'spec_helper'

describe Session do
  let(:user) {FactoryGirl.create(:user)}
  before do
    @session = user.sessions.build(ip_addr: "127.0.0.1", remember_token: Session.encrypt(Session.new_remember_token))
  end
  
  subject {@session}
  
  it {should be_valid }
  it {should respond_to(:ip_addr)}
  it {should respond_to(:permanent)}
  it { should respond_to(:user)}
  it { should respond_to(:remember_token)}
  it {should_not be_permanent}
  its(:user) {should eq user}
  describe "when set permanent" do
    before do
      @session.toggle!(:permanent)
      @session.save!
    end
    it {should be_permanent}
  end
  describe "remember token" do
    before { @session.save! }
    its(:remember_token) {should_not be_blank}
  end
end
