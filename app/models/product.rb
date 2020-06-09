class Product < ApplicationRecord
  belongs_to :merchant
  has_one :order_item
end
