class Product < ApplicationRecord
  belongs_to :merchant
  has_one :order_item
  #need to clarify this because if there's 10 plants and all get purchased, should see 10 order items
  #product has many order items.... 
  #has_many: order_item

  #PER Jess: quantity is an attribute of the model 
end


#product.order_items..will give all order items with this product  vs product.order_item ..this is just one