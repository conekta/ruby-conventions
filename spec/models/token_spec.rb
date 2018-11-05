require 'rails_helper'

RSpec.describe Token, type: :model do
  subject { FactoryBot.build :token }

  describe :validations do
    it { should validate_presence_of(:user) }
    it { is_expected.to define_enum_for(:token_type).with([:authentication, :account_confirmation, :password_reset, :email_change]) }
  end

  describe :associations do
    it { is_expected.to belong_to(:user) }
  end

  describe :callbacks do
    it "should set expiration date before creation" do
      subject.save!
      expect(subject.reload.expires_at).to_not be_nil
    end

    it "should set a random token before creation" do
      subject.save!
      expect(subject.reload.token).to_not be_empty
    end
  end

end
