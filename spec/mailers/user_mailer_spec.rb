require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "welcome_message" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.welcome_message(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Welcome to Wallet API!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([ENV['DEFAULT_MAIL_ADDRESS']])
    end

  end
end
