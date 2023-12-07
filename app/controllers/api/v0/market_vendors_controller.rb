class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_response
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  
  def create
    market_id = params[:market_vendor][:market_id]
    vendor_id = params[:market_vendor][:vendor_id]
    
    market_vendor = MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id)

    return unprocessable_entity(market_id, vendor_id) if market_vendor.present?

    MarketVendorSerializer.new(MarketVendor.create!(market_vendor_params))
    render json: {message: 'Successfully added vendor to market'}, status: :created
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_vendor_params)
    market_vendor_params
    
    return not_found_response(not_found_message) if market_vendor.nil?

    market_vendor.destroy
    head :no_content
  end

  private

  def unprocessable_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
    .serialize_json, status: :not_found
  end

  def unprocessable_entity(market_id, vendor_id)
    render json: ErrorSerializer.new(ErrorMessage.new("Validation failed: Market vendor asociation between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists", 422))
    .serialize_json, status: :unprocessable_entity
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception, 404))
    .serialize_json, status: :not_found
  end

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id )
  end

  def not_found_message
    array = market_vendor_params.to_h.to_a
    string = array.map{|pair| pair.join("=")}.join(" AND ")
    "Validation failed: Market vendor asociation between market with #{string}"
  end


end
