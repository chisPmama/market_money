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

    it "returns an error status, invalid parameter: 404 (sad path)" do
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

    it "returns an error status, already exists: 422 (sad path)" do
      create(:vendor, id: 1)
      create(:market, id: 1)
      create(:market_vendor, market_id: 1, vendor_id: 1)

      market_vendor_params = ({
                                "market_id": 1,
                                "vendor_id": 1
                           })
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(422)

      error_vendor = JSON.parse(response.body, symbolize_names: true)

      expect(error_vendor).to have_key(:errors)
      expect(error_vendor[:errors]).to be_an(Array)
      expect(response.body).to include("Validation failed: Market vendor asociation between market with market_id=1 and vendor_id=1 already exists")
    end
  end

  describe "Destroy a MarketVendor" do
    it "can destroy an existing market vendor and not send back a response" do
      create(:vendor, id: 1)
      create(:market, id: 1)
      create(:market_vendor, market_id: 1, vendor_id: 1)

      expect(MarketVendor.count).to eq(1)

      delete "/api/v0/market_vendors",
      headers: {"CONTENT_TYPE" => "application/json"}, 
      params: JSON.generate( {
        "market_vendor": {
                          "market_id": 1,
                          "vendor_id": 1
                         }
      })

      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(MarketVendor.count).to eq(0)
      expect(response.body.blank?).to eq(true)
    end

    it "can return a 422 error when a Market Vendor does not exist (sad path)" do
      create(:vendor, id: 1)
      create(:market, id: 1)
      create(:market_vendor, market_id: 1, vendor_id: 1)

      expect(MarketVendor.count).to eq(1)

      delete "/api/v0/market_vendors",
      headers: {"CONTENT_TYPE" => "application/json"}, 
      params: JSON.generate( {
        "market_vendor": {
                          "market_id": 12345,
                          "vendor_id": 12345
                         }
      })

      expect(MarketVendor.count).to eq(1)
      expect(response).to_not be_successful
      expect(response.status).to eq(422)
      expect(response.body).to include("Validation failed: Market vendor asociation between market with market_id=")
    end

    xit "can return a 204 error when a Market Vendor cannot be found (204)" do


    end
  end
end