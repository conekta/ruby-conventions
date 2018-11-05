module Transactions

  class CreateTransactionService

    attr_reader :output, :errors, :messages, :transaction_args

    def initialize(transaction_params, user)
      @errors = []
      @messages = []
      @transaction_params = transaction_params
      @user = user
    end

    def perform
      # clear old data
      @output = nil
      @errors.clear
      @messages.clear

      return false unless valid_transaction?

      if @transaction.transfer?
        create_transfer
      elsif @transaction.deposit?
        create_deposit
      elsif @transaction.withdrawal?
        create_withdrawal
      else
        @errors << "Unknown transaction type"
      end

      @errors.empty?
    end

    private

    def valid_transaction?
      @transaction = @user.transactions.build(@transaction_params.except(:transferable))

      if @transaction.flat_fee? || @transaction.variable_fee?
        @errors << "Invalid transaction type"
      end

      @errors.empty?
    end

    def create_transfer
      @transaction.transferable = transferable

      if @transaction.transferable.user.email == @user.email
        @errors << "You cannot transfer money to yourself"
        return false
      end

      return false unless enough_balance?

      ActiveRecord::Base.transaction do
        # get the fee
        fee = Fee.within_range(@transaction.amount)
        flat_fee = fee.flat_fee
        variable_fee = (@transaction.amount * fee.variable_fee)/100
        total = flat_fee + variable_fee + @transaction.amount

        # create the actual transaction
        @transaction.description ||= "#{@transaction.transaction_type.humanize} to #{@transaction.transferable.user.email}"
        @transaction.user_balance = (@user.account.balance - @transaction.amount)
        @transaction.transferable_balance = (@transaction.transferable.balance + @transaction.amount)
        @transaction.transferable.balance =  (@transaction.transferable.balance + @transaction.amount)

        # these are triggered by the above and they go to the internal account
        @flat_fee_transaction = Transaction.new
        @flat_fee_transaction.transaction_type = Transaction.transaction_types[:flat_fee]
        @flat_fee_transaction.transferable = Account.where(account_type: Account.account_types[:internal]).first
        @flat_fee_transaction.amount = flat_fee
        @flat_fee_transaction.user_balance = (@transaction.user_balance - flat_fee)
        @flat_fee_transaction.transferable_balance = (@transaction.transferable.balance + flat_fee)
        @flat_fee_transaction.transferable.balance = (@transaction.transferable.balance + flat_fee)
        @flat_fee_transaction.reference = @transaction
        @flat_fee_transaction.description = "flat fee"

        @variable_fee_transaction = Transaction.new
        @variable_fee_transaction.transaction_type = Transaction.transaction_types[:variable_fee]
        @variable_fee_transaction.transferable = Account.where(account_type: Account.account_types[:internal]).first
        @variable_fee_transaction.amount = variable_fee
        @variable_fee_transaction.user_balance = (@transaction.user_balance - variable_fee)
        @variable_fee_transaction.transferable_balance = (@transaction.transferable.balance + variable_fee)
        @variable_fee_transaction.transferable.balance = (@transaction.transferable.balance + variable_fee)
        @variable_fee_transaction.reference = @transaction
        @variable_fee_transaction.description = "variable fee"

        @transaction.save!
        @flat_fee_transaction.save!
        @variable_fee_transaction.save!
        @user.account.balance = (@user.account.balance - total)
        @user.save!

        # send notification
        TransactionMailer.notification(@transaction).deliver

        @output = @transaction
      end
    end

    def create_withdrawal
      @transaction.transferable = transferable

      if @user.cards.where(id: @transaction.transferable.id).blank?
        @errors << "You can only withdraw money from your own cards"
        return false
      end

      return false unless enough_balance?

      # get authorization from bank
      service = BankSimulator::DepositFundsService.new({amount: @transaction.amount, bank_token: transferable.bank_token})
      if service.perform
        authorization_code = service.output
      else
        @errors.concat(service.errors)
        return false
      end

      ActiveRecord::Base.transaction do
        # create the actual transaction
        @transaction.description = "#{@transaction.transaction_type.humanize} to XXXX-XXXX-XXXX-#{@transaction.transferable.last_4} [AUTHORIZATION: #{authorization_code}]"
        @transaction.user_balance = (@user.account.balance - @transaction.amount)
        @transaction.transferable_balance = 0
        @user.account.balance = (@user.account.balance - @transaction.amount)
        @transaction.save!
        @user.save!
        @output = @transaction

        # send notification
        TransactionMailer.notification(@transaction).deliver
      end

    end

    def create_deposit
      @transaction.transferable = transferable

      if @user.cards.where(id: @transaction.transferable.id).blank?
        @errors << "You can only deposit money from your own cards"
        return false
      end

      # get authorization from bank
      service = BankSimulator::WithdrawFundsService.new({amount: @transaction.amount, bank_token: transferable.bank_token})
      if service.perform
        authorization_code = service.output
      else
        @errors.concat(service.errors)
        return false
      end

      ActiveRecord::Base.transaction do
        # create the actual transaction
        @transaction.description = "#{@transaction.transaction_type.humanize} to XXXX-XXXX-XXXX-#{@transaction.transferable.last_4} [AUTHORIZATION: #{authorization_code}]"
        @transaction.user_balance = (@user.account.balance + @transaction.amount)
        @transaction.transferable_balance = 0
        @user.account.balance = (@user.account.balance + @transaction.amount)
        @transaction.save!
        @user.save!
        @output = @transaction

        # send notification
        TransactionMailer.notification(@transaction).deliver
      end
    end

    def transferable
      transferable_id = @transaction_params[:transferable][:id]
      if @transaction.transfer?
        Account.find(transferable_id)
      elsif @transaction.deposit? || @transaction.withdrawal?
        @user.cards.find(transferable_id)
      end
    end

    def enough_balance?
      total = @transaction.amount
      if @transaction.transfer?
        fee = Fee.within_range(@transaction.amount)
        total += fee.flat_fee
        total += (@transaction.amount * fee.variable_fee)/100
      end

      @errors << "Account does not have enough balance" if total > @user.account.balance
      @errors.empty?
    end
  end
end
