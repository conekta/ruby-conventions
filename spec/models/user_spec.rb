require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryBot.build :user }

  describe :validations do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:role) }
    it { is_expected.to define_enum_for(:role).with([:customer, :admin]) }
    it { should validate_presence_of(:status) }
    it { is_expected.to define_enum_for(:status).with([:active, :unconfirmed, :disabled, :removed]) }
    it { should validate_length_of(:password).is_at_least(8).on(:create) }
  end

  describe :associations do
    it { is_expected.to have_many(:tokens).dependent(:destroy) }
    it { is_expected.to have_many(:cards).dependent(:destroy) }
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_one(:account).dependent(:destroy) }
  end

end
