require 'rails_helper'

RSpec.describe Transaction, type: :model do
  subject { FactoryBot.build(:transaction, :with_reference) }

  describe :validations do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:transferable_balance) }
    it { should validate_numericality_of(:transferable_balance).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:user_balance) }
    it { should validate_numericality_of(:user_balance).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:description) }
    it { is_expected.to define_enum_for(:transaction_type).with([:transfer, :deposit, :withdrawal, :flat_fee, :variable_fee]) }

    context "if transaction is flat fee" do
      before :each do
        subject.flat_fee!
      end
      it { should validate_presence_of(:reference) }
    end

    context "if transaction is variable fee" do
      before :each do
        subject.variable_fee!
      end
      it { should validate_presence_of(:reference) }
    end

  end

  describe :associations do
    it { is_expected.to belong_to(:transferable) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:reference).class_name("Transaction").with_foreign_key("reference_id") }
  end
end
