class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates :name, :description, :contact_name, :contact_phone, presence: true
  validates :credit_accepted, inclusion: [true, false]

  def self.missing_params(vendor_params)
    params_hash = vendor_params.to_h
    vendor_params_list = ["name", "description", "contact_name", "contact_phone", "credit_accepted"]
    missing_keys = vendor_params_list - params_hash.keys
    return if missing_keys.empty?
    errors = missing_keys.map{|k| k.capitalize.split('_').join(' ')}
    messages = errors.map do |missing_param|
      "#{missing_param} can't be blank"
    end
    "Validation failed: " + messages.join(', ')
  end

end