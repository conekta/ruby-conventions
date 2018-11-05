class FeesController < ApplicationController

  load_and_authorize_resource

  # GET /fees
  # GET /fees.json
  def index
    @fees = paginate(@fees)
  end

  # GET /fees/1
  # GET /fees/1.json
  def show
  end

  # POST /fees
  # POST /fees.json
  def create
    if @fee.save
      render :show, status: :created, location: @fee
    else
      raise ApiErrors::UnprocessableEntityError.new("Error while creating card", @fee.errors.full_messages)
    end
  end

  # PATCH/PUT /fees/1
  # PATCH/PUT /fees/1.json
  def update
    if @fee.update(fee_params)
      render :show, status: :ok, location: @fee
    else
      raise ApiErrors::UnprocessableEntityError.new("Error while updating card", @fee.errors.full_messages)
    end
  end

  # DELETE /fees/1
  # DELETE /fees/1.json
  def destroy
    @fee.destroy!
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def fee_params
    params.require(:fee).permit(:description, :lower_range, :upper_range, :flat_fee, :variable_fee)
  end
end
