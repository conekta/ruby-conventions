class UserMailer < ApplicationMailer
  default from: "Wallet API <#{ENV['DEFAULT_MAIL_ADDRESS']}>"

  def welcome_message(user)
    @user = user
    mail(to: user.email, subject: "Welcome to Wallet API!")
  end
end
