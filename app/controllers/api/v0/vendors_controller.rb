class Api::V0::VendorsController < ApplicationController

  def index
    market = Market.find(params[:market_id])
    market_vendors = market.vendors
    render json: VendorSerializer.new(market_vendors)
  end

  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    render json: VendorSerializer.new(Vendor.create!(vendor_params)), status: 201
  end

  def update
    render json: VendorSerializer.new(Vendor.update!(params[:id],vendor_params))
  end

  def destroy
    Vendor.find(params[:id])
    render json: Vendor.delete(params[:id]), status: 204
  end

  private
  
  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted )
  end

end