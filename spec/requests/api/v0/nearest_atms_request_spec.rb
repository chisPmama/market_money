# require 'rails_helper'

# describe "Get Cash Dispensers Near a Market" do
#   before :each do
#     market = create(:market, lat: "35.077529",
#                              lon: "-106.600449")

#     get "/api/v0/markets/#{market.id}/nearest_atms"
#   end

#   xit "can return the closest ATM to the market" do
#     expect(response).to be_successful
#     expect(response.status).to eq(200)

#     atms = JSON.parse(response.body, symbolize_names: true)[:data]
#     binding.pry
#     expect(atms).to have_key(:id)
#     # expect(atms[:id]).to be_an(Null)

#     # expect(atms).to have_key(:type)
#     # expect(atms[:type]).to eq("atm")

#     atms = atms.first[:attributes]

#     expect(atms).to have_key(:name)
#     expect(atms[:name]).to eq("ATM")
#     # expect(atms[:address]).to eq("3902 Central Avenue Southeast, Albuquerque, NM 87108")
#     expect(atms[:lat]).to eq(35.077529)
#     expect(atms[:lon]).to eq(-106.600449)
#     expect(atms[:distance]).to eq(0)
#   end
# end