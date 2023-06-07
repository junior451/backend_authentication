require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it { should have_many(:groups).through(:user_groups) }
 
  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "is invalid without an email" do
    user.email = ""
    expect(user).to_not be_valid
  end

  it "is invlaid without a username" do
    user.username = ""
    expect(user).to_not be_valid
  end

  it "is invalid without a password" do
    user = build(:user, password: "")
    expect(user).to_not be_valid
  end
end
