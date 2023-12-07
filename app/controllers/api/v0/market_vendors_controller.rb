class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_response

  def create
    begin
      render json: MarketVendorSerializer.new(MarketVendor.create!(market_vendor_params)), status: 201
    rescue ActiveRecord::RecordInvalid => exception
      unprocessable_response(exception)
    end
  end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serialize_json, status: :not_found
  end

  def unprocessable_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
    .serialize_json, status: :bad_request
  end

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id )
  end


end
