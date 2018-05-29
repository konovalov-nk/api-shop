require 'rails_helper'

RSpec.describe User, type: :model do
  context 'given valid attributes' do
    before(:each) do
      @user = create(:user)
    end

    it 'is valid' do
      expect(@user).to be_valid
    end

    it 'has a full_name getter' do
      user = build(:user, first_name: 'John', last_name: 'Wick')
      expect(user.full_name).to eql('John Wick')
    end

    it 'has a country_name getter' do
      user = build(:user, country: 'usa')
      expect(user.country_name).to eql('United States of America')
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

    it 'is not valid without a first name' do
      user = build(:user, first_name: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without a last name' do
      user = build(:user, last_name: nil)
      expect(user).to_not be_valid
    end
  end
end
