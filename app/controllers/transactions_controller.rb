class TransactionsController < ApplicationController

  load_and_authorize_resource :user
  load_and_authorize_resource through: :user
  skip_load_resource only: :create

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = paginate(@transactions)
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # POST /transactions
  # POST /transactions.json
  def create
    service = Transactions::CreateTransactionService.new(create_params, @user)

    if service.perform
      @transaction = service.output
      render :show, status: :created, location: user_transaction_url(@transaction.user, @transaction)
    else
      raise ApiErrors::UnprocessableEntityError.new("Invalid transaction", service.errors)
    end
  end


  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_params
    params.require(:transaction).permit(:amount, :transaction_type, :description, transferable: :id)
  end
end
