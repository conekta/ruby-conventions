class TransactionMailer < ApplicationMailer
  default from: "Wallet API <#{ENV['DEFAULT_MAIL_ADDRESS']}>"

  def notification(transaction)
    @transaction = transaction
    @transferable = transaction.transferable
    @user = transaction.transferable.user

    if transaction.transfer?
      subject = "You have received money!"
      @message = "#{@transaction.user.full_name} (#{@transaction.user.email}) has sent you #{ActionController::Base.helpers.number_to_currency(@transaction.amount)}"
    elsif transaction.deposit?
      subject = "Funds added to your account"
      @message = "#{ActionController::Base.helpers.number_to_currency(@transaction.amount)} have been added to your wallet from your card ending in '#{@transferable.last_4}'"
    elsif transaction.withdrawal?
      subject = "Funds withdrawn from your account"
      @message = "#{ActionController::Base.helpers.number_to_currency(@transaction.amount)} have been moved from your wallet to your card ending in '#{@transferable.last_4}'"
    end


    mail(to: @user.email, subject: subject)
  end

end
