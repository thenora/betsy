class OrderItem < ApplicationRecord
  belongs_to :product
  # has_one :product  
  belongs_to :order

  validates :name, presence: true

  def check_product_inventory
    incoming_quantity = self.quantity
    matching_product = Product.find_by(id: self.product_id)

    matching_product.inventory >= incoming_quantity ? true : false
  end

  def reduce_inventory
    matching_product = Product.find_by(id: self.product_id)

    matching_product.inventory -= self.quantity
    matching_product.save
  end

  def add_inventory
    matching_product = Product.find_by(id: self.product_id)

    matching_product.inventory += self.quantity
    matching_product.save
  end
end
