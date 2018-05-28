require 'rails_helper'

RSpec.describe User, type: :model do
  context 'given valid attributes' do
    before(:each) do
      @user = create(:user)
    end

    it 'is valid' do
      expect(@user).to be_valid
    end
  end

  context 'given invalid attributes' do
    it 'is not valid without an email' do
      user = build(:user, email: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without a password' do
      user = build(:user, password: nil)
      expect(user).to_not be_valid
    end
  end
end
