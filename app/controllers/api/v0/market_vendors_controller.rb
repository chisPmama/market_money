class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_response

  
  def create
    market_id = params[:market_vendor][:market_id]
    vendor_id = params[:market_vendor][:vendor_id]

    market_vendor = MarketVendor.find_by(
                                         market_id: market_id, 
                                         vendor_id: vendor_id
                                        )
    
    return unprocessable_entity(market_id, vendor_id) if market_vendor.present?

    begin
      MarketVendorSerializer.new(MarketVendor.create!(market_vendor_params))
      render json: {message: 'Successfully added vendor to market'}, status: :created
    rescue ActiveRecord::RecordInvalid => exception
      unprocessable_response(exception)
    end
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

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id )
  end


end
