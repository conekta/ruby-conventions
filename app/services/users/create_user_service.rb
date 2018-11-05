module Users

  class CreateUserService

    attr_reader :output, :errors, :messages, :user_args

    def initialize(user_params)
      @errors = []
      @messages = []
      @user_params = user_params
    end

    def perform
      # clear old data
      @output = nil
      @errors.clear
      @messages.clear

      return false unless valid_user?
      UserMailer.welcome_message(@user).deliver

      @errors.empty?
    end

    private

    def valid_user?
      @user = User.new(@user_params)
      if @user.valid?
        # set a default zero balance for the user and create an account
        @user.build_account(balance: 0, account_type: Account.account_types[:customer])
        @user.save!
        @output = @user
      else
        @errors << @user.errors.full_messages
      end

      @errors.empty?
    end
  end
end