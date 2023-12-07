require 'rails_helper'

describe "Market Vendors API" do
  describe "Create a MarketVendor" do
    it "can create a new market vendor and return a success message" do
      create(:vendor, id: 1)
      create(:market, id: 1)
      market_vendor_params = ({
                                "market_id": 1,
                                "vendor_id": 1
                           })
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      created_market_vendor = MarketVendor.last

      expect(response).to be_successful
      expect(response.status).to eq(201)

      expect(created_market_vendor.market_id).to eq(1)
      expect(created_market_vendor.vendor_id).to eq(1)

      response_JSON = JSON.parse(response.body, symbolize_names: true)
      
      expect(response.body).to include('Successfully added vendor to market')
      expect(response_JSON).to have_key(:message)
      expect(response_JSON[:message]).to be_a(String)
    end

  end

end