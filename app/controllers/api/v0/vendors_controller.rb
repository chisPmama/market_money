class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find(params[:market_id])
    market_vendors = market.vendors
    render json: VendorSerializer.new(market_vendors)
  end
end