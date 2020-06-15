class OrderItem < ApplicationRecord
  belongs_to :product
  # has_one :product  
  belongs_to :order

  validates :name, presence: true
end
