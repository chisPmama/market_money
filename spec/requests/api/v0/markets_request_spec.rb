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

        markets.each do |market|
          market = market[:attributes]

          expect(market).to have_key(:vendor_count)
          expect(market[:vendor_count]).to be_a(Integer)
        end
      end
  end

  describe 'Get One Market' do
    it "can get one market by its id (happy path)" do
      id = create(:market).id
      get "/api/v0/markets/#{id}"
      market = JSON.parse(response.body, symbolize_names: true)
      market = market[:data]

      expect(response).to be_successful

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

      expect(market).to have_key(:vendor_count)
      expect(market[:vendor_count]).to be_a(Integer)
    end

    it "return an error status: 404 (sad path)" do
      get "/api/v0/markets/123123123123"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      error_market = JSON.parse(response.body, symbolize_names: true)

      expect(error_market).to have_key(:errors)
      expect(error_market[:errors]).to be_an(Array)
      expect(response.body).to include("Couldn't find Market with 'id'=")
    end
  end

  describe 'Search Markets by state, city, and/or name' do
    before :each do
      @market1 = create(:market, name: "Nob Hill Growers' Market",
                                city: "Albuquerque",
                                state: "New Mexico")
      @market2 = create(:market, name: "ChisP Paw Paw Shoppe",
                                city: "Chicago",
                                state: "Illinois")
      @market3 = create(:market, name: "Hueco Mountain Hut",
                                city: "El Paso",
                                state: "Texas")

      market_vendors = []

      5.times do 
        market_vendors << create(:vendor)
      end
      market_vendors.each do |mv|
        MarketVendor.create(market_id:@market1.id, vendor_id:mv.id)
      end
    end

    it 'can take a direct query of city, state, and part of name for market search' do
      get "/api/v0/markets/search?city=albuquerque&state=new Mexico&name=Nob hill"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      search_market = JSON.parse(response.body, symbolize_names: true)[:data]
      
      search_market = search_market.first

      expect(search_market).to have_key(:id)
      expect(search_market[:id]).to eq(@market1.id.to_s)
      
      search_market = search_market[:attributes]


      expect(search_market).to have_key(:name)
      expect(search_market[:name]).to eq("Nob Hill Growers' Market")

      expect(search_market).to have_key(:vendor_count)
      expect(search_market[:vendor_count]).to eq(5)     
    end
    
    describe 'Happy Paths for Queries' do
      it 'works for state and city' do
        get "/api/v0/markets/search?city=albuquerque&state=new Mexico"
  
        search_market = JSON.parse(response.body, symbolize_names: true)[:data]
        search_market = search_market.first
  
        expect(search_market).to have_key(:id)
        expect(search_market[:id]).to eq(@market1.id.to_s)   
      end
  
      it 'works for state only' do
        get "/api/v0/markets/search?state=new Mexico"
  
        search_market = JSON.parse(response.body, symbolize_names: true)[:data]
        search_market = search_market.first
  
        expect(search_market).to have_key(:id)
        expect(search_market[:id]).to eq(@market1.id.to_s)    
      end
  
      it "works for state and name" do
        get "/api/v0/markets/search?state=new Mexico&name=Nob hill"
  
        search_market = JSON.parse(response.body, symbolize_names: true)[:data]
        search_market = search_market.first
  
        expect(search_market).to have_key(:id)
        expect(search_market[:id]).to eq(@market1.id.to_s) 
      end

      it "works for name only" do
        get "/api/v0/markets/search?name=Nob hill"
  
        search_market = JSON.parse(response.body, symbolize_names: true)[:data]
        search_market = search_market.first
  
        expect(search_market).to have_key(:id)
        expect(search_market[:id]).to eq(@market1.id.to_s) 
      end

      it "searching parameters, but no returns" do
        get "/api/v0/markets/search?name=Test"

        expect(response).to be_successful
        expect(response.status).to eq(200)
  
        search_market = JSON.parse(response.body, symbolize_names: true)[:data]
  
        expect(search_market).to be_an(Array)
        expect(search_market).to be_empty
      end
    end

    describe 'Sad Paths for Queries' do
      it 'does not work for city only' do
        get "/api/v0/markets/search?city=albuquerque"

        expect(response).to_not be_successful
        expect(response.status).to eq(422)
  
        error_market = JSON.parse(response.body, symbolize_names: true)

        expect(error_market).to have_key(:errors)
        expect(error_market[:errors]).to be_an(Array)
        expect(response.body).to include("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")      
      end

      it 'does not work for city and name' do
        get "/api/v0/markets/search?city=albuquerque&name=Nob hill"

        expect(response).to_not be_successful
        expect(response.status).to eq(422)
  
        error_market = JSON.parse(response.body, symbolize_names: true)

        expect(error_market).to have_key(:errors)
        expect(error_market[:errors]).to be_an(Array)
        expect(response.body).to include("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")      
      end
    end
  end

end