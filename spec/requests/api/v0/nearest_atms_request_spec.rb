require 'rails_helper'

describe "Get Cash Dispensers Near a Market" do
  before :each do
    market_params = ({
                      name: "Nob Hill Growers' Market",
                      street: "Lead & Morningside SE",
                      city: "Albuquerque",
                      county: "Bernalillo",
                      state: "New Mexico",
                      zip: "null",
                      lat: "35.077529",
                      lon: "-106.600449"
                    })
    headers = {"CONTENT_TYPE" => "application/json"}
    @market = Market.create!(market_params)
    get "/api/v0/markets/#{@market.id}/nearest_atms", headers: headers
  end

  it "can return the closest ATM to the market" do
    expect(response).to be_successful
    expect(response.status).to eq(200)

    atms = JSON.parse(response.body, symbolize_names: true)[:data]
    # binding.pry
  end
end