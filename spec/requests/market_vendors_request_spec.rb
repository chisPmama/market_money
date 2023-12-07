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

    it "returns an error status: 404 (sad path)" do
      create(:vendor, id: 1)
      create(:market, id: 1)
      market_vendor_params = ({
                                "market_id": 333,
                                "vendor_id": 1
                           })
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_vendor = JSON.parse(response.body, symbolize_names: true)

      expect(error_vendor).to have_key(:errors)
      expect(error_vendor[:errors]).to be_an(Array)
      expect(response.body).to include("Validation failed: Market must exist")
    end
  end

end