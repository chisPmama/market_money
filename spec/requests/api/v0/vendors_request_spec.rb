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

    it "return an error status: 404 (sad path)" do
      get "/api/v0/markets/123123123123/vendors"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_market = JSON.parse(response.body, symbolize_names: true)

      expect(error_market).to have_key(:errors)
      expect(error_market[:errors]).to be_an(Array)
      expect(response.body).to include("Couldn't find Market with 'id'=")
    end
  end

  describe 'Get One Vendor' do
    it "can get one vendor by its id (happy path)" do
      id = create(:vendor).id
      get "/api/v0/vendors/#{id}"
      vendor = JSON.parse(response.body, symbolize_names: true)
      vendor = vendor[:data]
  
      expect(response).to be_successful
  
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_an(String)
  
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

    it "return an error status: 404 (sad path)" do
      get "/api/v0/vendors/123123123123"
      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_vendor = JSON.parse(response.body, symbolize_names: true)

      expect(error_vendor).to have_key(:errors)
      expect(error_vendor[:errors]).to be_an(Array)
      expect(response.body).to include("Couldn't find Vendor with 'id'=")
    end
  end

  describe "Create a Vendor" do
    it "can create a new vendor" do
      vendor_params = ({
                        name: 'ChisP Supplier for Dog Treats and Human Produce',
                        description: 'A place for bad dogs and good humans',
                        contact_name: 'Chispa Yur-Gorzlancyk',
                        contact_phone: '903-940-1230',
                        credit_accepted: true
                })
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last

      expect(response).to be_successful
      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])
    end
  
  end

end