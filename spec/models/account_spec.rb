require 'rails_helper'

RSpec.describe Account, type: :model do
  subject { FactoryBot.build :account }

  describe :validations do
    it { should validate_presence_of(:user) }
    it { should validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
    it { is_expected.to define_enum_for(:account_type).with([:customer, :internal]) }
  end

  describe :associations do
    it { is_expected.to belong_to(:user) }
  end

end
