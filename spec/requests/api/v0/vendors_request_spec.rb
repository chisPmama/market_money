require 'rails_helper'

describe "Vendors API" do
  describe "Get All Vendors for a Market" do
    it "can return a list of the vendors that belongs to that specific merchant" do
      market1 = create(:market)
      vendor1 = create(:vendor)
      vendor2 = create(:vendor)
      vendor3 = create(:vendor)
    
      MarketVendor.create(market_id:market1.id, vendor_id:vendor1.id)
      MarketVendor.create(market_id:market1.id, vendor_id:vendor2.id)
      MarketVendor.create(market_id:market1.id, vendor_id:vendor3.id)
    
      get "/api/v0/markets/#{market1.id}/vendors"
      

    end

  end
end