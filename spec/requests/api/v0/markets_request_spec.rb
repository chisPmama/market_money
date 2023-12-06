require 'rails_helper'

describe "Markets API" do
  describe 'Get All Markets' do
    before :each do
      create_list(:market, 3)
      get '/api/v0/markets'
      expect(response).to be_successful
    end
    
    it "sends a list of all markets" do
      markets = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(markets.count).to eq(3)
  
      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_an(String)

        market = market[:attributes]

        expect(market).to have_key(:name)
        expect(market[:name]).to be_a(String)
  
        expect(market).to have_key(:street)
        expect(market[:street]).to be_a(String)
  
        expect(market).to have_key(:city)
        expect(market[:city]).to be_a(String)
  
        expect(market).to have_key(:county)
        expect(market[:county]).to be_a(String)
  
        expect(market).to have_key(:state)
        expect(market[:state]).to be_a(String)
  
        expect(market).to have_key(:state)
        expect(market[:state]).to be_a(String)
  
        expect(market).to have_key(:lat)
        expect(market[:lat]).to be_a(String)
  
        expect(market).to have_key(:lon)
        expect(market[:lon]).to be_a(String)
  
      end
    end
  
      it "can return an attribute of vendor count" do
        markets = JSON.parse(response.body, symbolize_names: true)[:data]
        create_list(:vendor, 3)
        binding.pry
        
        markets.each do |market|
          expect(market).to have_key(:vendor_count)
          expect(market[:vendor_count]).to be_a(Integer)
        end
      end
  end
end