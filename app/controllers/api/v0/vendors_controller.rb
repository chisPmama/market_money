class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_response

  def index
    begin
      market = Market.find(params[:market_id])
      market_vendors = market.vendors
      render json: VendorSerializer.new(market_vendors)
    rescue ActiveRecord::RecordNotFound => exception
      not_found_response(exception)
    end
  end

  def show
    begin
      render json: VendorSerializer.new(Vendor.find(params[:id]))
    rescue ActiveRecord::RecordNotFound => exception
      not_found_response(exception)
    end
  end

  def create
    begin
      render json: VendorSerializer.new(Vendor.create!(vendor_params)), status: 201
    rescue ActiveRecord::RecordInvalid => exception
      unprocessable_response(exception)
    end
  end

  def update
    begin
      render json: VendorSerializer.new(Vendor.update!(params[:id],vendor_params))
    rescue ActiveRecord::RecordNotFound => exception
      not_found_response(exception)
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
    .serialize_json, status: 400
  end

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted )
  end

end