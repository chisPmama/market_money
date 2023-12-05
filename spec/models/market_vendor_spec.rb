require "rails_helper"

RSpec.describe MarketVendor, type: :model do

  describe "relationships" do
    it { should belong_to :markets }
    it { should belong_to :vendors }
  end

end