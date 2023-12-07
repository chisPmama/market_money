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

  def create
    missing = Vendor.missing_params(vendor_params)
    
    if missing.nil?
      render json: VendorSerializer.new(Vendor.create!(vendor_params)), status: 201
    else
      render json: ErrorSerializer.new(ErrorMessage.new(missing, 400))
      .serialize_json, status: 400
    end
  end

  def update
    render json: VendorSerializer.new(Vendor.update(params[:id],vendor_params))
  end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
    .serialize_json, status: :not_found
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted )
  end

end