class Product < ApplicationRecord
  belongs_to :merchant
  has_one :order_item
  has_and_belongs_to_many :categories
  #need to clarify this because if there's 10 plants and all get purchased, should see 10 order items
  #product has many order items.... 
  #has_many: order_item

  #PER Jess: quantity is an attribute of the model 

  # ? Nora's thoughts: 
  # ? has_many :order_items
  # ? has_many :orders, through :order_items

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {only_float: true, greater_than: 0}
  validates :inventory, presence: true, numericality: {only_integer: true} 

end


#product.order_items..will give all order items with this product  vs product.order_item ..this is just one