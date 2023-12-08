require "rails_helper"

RSpec.describe Market, type: :model do

  describe "relationships" do       
    it { should have_many(:market_vendors) }
    it { should have_many(:vendors).through(:market_vendors) }
  end
  
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:county) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
  end

  describe '#vendor_count' do
    it 'returns how many vendors belong to that market' do
      market1 = create(:market, name: "Nob Hill Growers' Market",
                                 city: "Albuquerque",
                                 state: "New Mexico")
    
      market_vendors = []

      5.times do 
        market_vendors << create(:vendor)
      end
      market_vendors.each do |mv|
        MarketVendor.create(market_id:market1.id, vendor_id:mv.id)
      end

      expect(market1.vendor_count).to eq(5)
    end
  end
end