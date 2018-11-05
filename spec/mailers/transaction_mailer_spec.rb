require "rails_helper"

RSpec.describe TransactionMailer, type: :mailer do
  describe "transaction notification" do
    context "for a transfer" do
      let(:transaction) { FactoryBot.create(:transaction, transaction_type: Transaction.transaction_types[:transfer]) }
      let(:mail) { TransactionMailer.notification(transaction) }

      it "renders the headers" do
        expect(mail.subject).to eq("You have received money!")
        expect(mail.to).to eq([transaction.transferable.user.email])
        expect(mail.from).to eq([ENV['DEFAULT_MAIL_ADDRESS']])
      end
    end
    context "for a deposit" do
      let(:transferable) { FactoryBot.create(:card) }
      let(:transaction) { FactoryBot.create(:transaction, transaction_type: Transaction.transaction_types[:deposit], transferable: transferable) }
      let(:mail) { TransactionMailer.notification(transaction) }

      it "renders the headers" do
        expect(mail.subject).to eq("Funds added to your account")
        expect(mail.to).to eq([transaction.transferable.user.email])
        expect(mail.from).to eq([ENV['DEFAULT_MAIL_ADDRESS']])
      end
    end
    context "for a withdrawal" do
      let(:transferable) { FactoryBot.create(:card) }
      let(:transaction) { FactoryBot.create(:transaction, transaction_type: Transaction.transaction_types[:withdrawal], transferable: transferable) }
      let(:mail) { TransactionMailer.notification(transaction) }

      it "renders the headers" do
        expect(mail.subject).to eq("Funds withdrawn from your account")
        expect(mail.to).to eq([transaction.transferable.user.email])
        expect(mail.from).to eq([ENV['DEFAULT_MAIL_ADDRESS']])
      end
    end
  end
end
