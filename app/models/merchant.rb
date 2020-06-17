class Merchant < ApplicationRecord
  validates :username, :email, :uid, :provider, presence: :true

  has_many :products
  has_many :order_items, through: :products

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    merchant.username = auth_hash["info"]["nickname"]
    merchant.email = auth_hash["info"]["email"]

    return merchant
  end
end