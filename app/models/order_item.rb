class OrderItem < ApplicationRecord
  has_one :product
  belongs_to :order

  validates :name, presence: true
end
