class MarketVendorSerializer
  include JSONAPI::Serializer
  attributes :market_id, :vendor_id

  belongs_to :vendor
  belongs_to :market

end
