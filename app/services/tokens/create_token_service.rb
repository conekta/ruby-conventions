module Tokens

  class CreateTokenService

    attr_reader :output, :errors, :messages, :token_args

    def initialize(token_params)
      @errors = []
      @messages = []
      @token_params = token_params
    end

    def perform
      # clear old data
      @output = nil
      @errors.clear
      @messages.clear

      return false unless valid_token?

      @errors.empty?
    end

    private

    def valid_token?
      email = @token_params.fetch(:user).fetch(:email)
      password = @token_params.fetch(:user).fetch(:password)

      @token = Token.new(@token_params.except(:user))
      @token.user = User.find_by(email: email) if @token_params[:user].present?

      if @token.user.blank?
        @errors << "Invalid credentials"
      elsif @token.user.present? && @token.authentication?
        @errors << "Invalid credentials" unless @token.user.authenticate(password)
      end

      if @token.valid?
        @token.save!
        @output = @token
      else
        @errors << @token.errors.full_messages
      end

      @errors.empty?
    end

  end

end