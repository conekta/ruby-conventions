class CardsController < ApplicationController

  load_and_authorize_resource :user
  load_and_authorize_resource through: :user
  skip_load_resource only: :create

  # GET /cards
  # GET /cards.json
  def index
    @cards = paginate(@cards)
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    # thinking wether this is better than returning a 403 through cancan ?
    #
    # if current_user.customer? && @card.removed?
    #   raise ApiErrors::NotFoundError.new("No card with id #{params[:id]} found")
    # end
  end

  # POST /cards
  # POST /cards.json
  def create
    service = Cards::CreateCardService.new(create_params, @user)

    if service.perform
      @card = service.output
      render :show, status: :created, location: user_cards_url(@card.user, @card)
    else
      raise ApiErrors::UnprocessableEntityError.new("Invalid card data", service.errors)
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    service = Cards::DestroyCardService.new(@card)

    if service.perform
      head :no_content
    else
      raise ApiErrors::UnprocessableEntityError.new("Cannot remove card", service.errors)
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def create_params
    params.require(:card).permit([
      :name_on_card,
      :number,
      :csc,
      :expiration_year,
      :expiration_month,
      :card_type,
      :issuer
    ])
  end
end
