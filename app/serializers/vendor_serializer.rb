class VendorSerializer < ActiveModel::Serializer

  def self.format_vendors(vendors)
    vendors.map do |vendor|
      {
        id: vendor.id,
        name: vendor.name,
        description: vendor.description,
        contact_name: vendor.contact_name,
        contact_phone: vendor.contact_phone,
        credit_accepted: vendor.credit_accepted,
      }
    end
  end
end