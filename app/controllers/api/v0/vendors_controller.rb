class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find_by(id: params[:market_id])

    if market
      market_vendors = market.vendors
      render json: VendorSerializer.new(market_vendors)
    else
      render json: { status: 404, errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }
    end
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end
end