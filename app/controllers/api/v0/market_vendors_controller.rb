class Api::V0::MarketVendorsController < ApplicationController
  
  def create
    market_vendor = MarketVendor.find_by(market_vendor_params)

    return unprocessable_entity(unprocessable_message) if market_vendor.present?

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

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id )
  end

  def pp_params
    array = market_vendor_params.to_h.to_a
    string = array.map{|pair| pair.join("=")}.join(" AND ")
  end

  def not_found_message
    "No MarketVendor with #{pp_params} exists"
  end

  def unprocessable_message
    "Validation failed: Market vendor association between market with #{pp_params.downcase} already exists"
  end

end
