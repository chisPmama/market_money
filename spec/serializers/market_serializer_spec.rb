# require 'rails_helper'

# RSpec.describe MarketSerializer do
#   let(:market) { create(:market) }
#   binding.pry

#   xit 'serializes the market correctly' do
#     serialized_market = MarketSerializer.new(market).as_json

#     expect(serialized_market).to include(
#       id: market.id,
#         name: market.name,
#         street: market.street,
#         city: market.city,
#         county: market.county,
#         state: market.state,
#         zip: market.zip,
#         lat: market.lat,
#         lon: market.lon
#     )
#   end
# end