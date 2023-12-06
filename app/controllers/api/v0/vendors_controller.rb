class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    begin
      market = Market.find(params[:market_id])
      market_vendors = market.vendors
      render json: VendorSerializer.new(market_vendors)
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
    end
  end

  def show
    begin
      render json: VendorSerializer.new(Vendor.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
    end
  end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serialize_json, status: :not_found
  end
end