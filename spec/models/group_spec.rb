require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:group) { build(:group) }

  it { should have_many(:users).through(:user_groups) }


  it "valid with valid attributes" do
    expect(group).to be_valid
  end

  it "is invalid without a name" do
    group.name = nil
    expect(group).to_not be_valid
  end

  it "invalid if name is not unique" do
    group.save

    group2 = build(:group, name: "new_group1")

    group2.save

    expect(group2.errors.full_messages.first).to eq("Name has already been taken")
  end
end
