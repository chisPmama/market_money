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

      expect(response).to be_successful
      market_vendors = JSON.parse(response.body, symbolize_names: true)[:data]
      vendor_ids = [vendor1.id, vendor2.id, vendor3.id]

      expect(market_vendors.count).to eq(3)

      market_vendors.each do |vendor|
        check = vendor_ids.find{|v_id| v_id == vendor[:id].to_i}
        expect(vendor).to have_key(:id)
        expect(vendor[:id]).to be_an(String)
        expect(check).to eq(vendor[:id].to_i)

        vendor = vendor[:attributes]

        expect(vendor).to have_key(:name)
        expect(vendor[:name]).to be_an(String)

        expect(vendor).to have_key(:description)
        expect(vendor[:description]).to be_an(String)

        expect(vendor).to have_key(:contact_name)
        expect(vendor[:contact_name]).to be_an(String)

        expect(vendor).to have_key(:contact_phone)
        expect(vendor[:contact_phone]).to be_an(String)

        expect(vendor).to have_key(:credit_accepted)
        expect(vendor[:credit_accepted]).to be_kind_of(TrueClass).or be_kind_of(FalseClass)
      end
    end

  end
end