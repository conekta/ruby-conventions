class TokensController < ApplicationController

  skip_before_action :authenticate
  before_action :set_token, only: :show

  # POST /tokens
  # POST /tokens.json
  def create
    service = Tokens::CreateTokenService.new(token_params)

    if service.perform
      @token = service.output
      render :show, status: :created, location: @token
    else
      raise ApiErrors::BadRequestError.new("Error while creating new token", service.errors)
    end
  end

  def show

  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def token_params
      params.require(:token).permit(:token_type, user: [:email, :password])
    end

    def set_token
      @token = Token.find(params.fetch(:id))
    end
end
