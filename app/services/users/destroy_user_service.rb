module Users

  class DestroyUserService

    attr_reader :output, :errors, :messages, :user

    def initialize(user)
      @errors = []
      @messages = []
      @user = user
    end

    def perform
      # clear old data
      @output = nil
      @errors.clear
      @messages.clear

      return false unless able_to_remove?

      @errors.empty?
    end

    private

    def able_to_remove?
      # first we need to check whether the user has a balance, if it does then
      # we need to notify to transfer the money
      if @user.account.balance > 0
        @errors << "User currently has #{ActiveSupport::NumberHelper.number_to_currency(@user.account.balance)} in balance so money should be withdrawn before removing the account."
        return false
      end

      # If user has transactions then we will just disable the account
      if @user.transactions.present?
        @user.removed!
      else
        @user.destroy!
      end

      @errors.empty?
    end
  end

end