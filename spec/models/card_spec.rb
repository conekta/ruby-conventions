require 'rails_helper'

RSpec.describe Card, type: :model do
  subject { FactoryBot.build :card }

  describe :validations do
    it { should validate_presence_of(:card_type) }
    it { is_expected.to define_enum_for(:card_type).with([:credit, :debit]) }
    it { is_expected.to define_enum_for(:status).with([:active, :removed]) }
    it { should validate_presence_of(:last_4) }
    it { should validate_length_of(:last_4).is_equal_to(4) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:expiration) }
    it { should validate_presence_of(:bank_token) }

    context "when card has transactions" do
      let!(:user) { FactoryBot.create(:user_with_cards) }
      let!(:card) { user.cards.first }
      let!(:transaction) { FactoryBot.create(:transaction, transaction_type: Transaction.transaction_types[:withdrawal], transferable: card) }

      it "should validate transactions on destroy" do
        expect(card.destroy).to be false
        expect { card.destroy }.to_not change(Card, :count)
      end
    end
  end

  describe :associations do
    it { is_expected.to belong_to(:user) }
  end

  describe :callbacks do
    it "should override expiration day" do
      subject.save!
      expect(subject.reload.expiration.strftime("%d")).to eq("01")
    end

    it "should enable card before create" do
      subject.save!
      expect(subject.active?).to be true
    end
  end

  describe :scopes do
    before :each do
      4.times do |n|
        if n.odd?
          FactoryBot.create(:card, expiration: 1.month.ago)
        else
          FactoryBot.create(:card)
        end
      end
    end
    it "should have an expired scope" do
      expect(Card).to respond_to(:expired)
    end
    it "returns only expired records" do
      expect(Card.expired.count).to eq(2)
    end
  end
end
