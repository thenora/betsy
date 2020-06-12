require "test_helper"

describe OrdersController do
  before do
    @merchant = Merchant.create(
      username: 'Leroy Jenkins',
      email: 'leroy@gmail.com'
    )
    @product = Product.create(
      name: 'Plant One', 
      price: 5.00, 
      description: 'This is a fake plant.',
      inventory: 5,
      merchant_id: @merchant.id
    )
  end
  
  let (:new_item_hash) {
    {
      order_item: {
        name: @product.name,
        price: @product.price,
        quantity: 1,
        product_id: @product.id
      }
    }
  }
  
  describe "cart" do
    it "finds a list of orders if session order is populated" do
      expect {
        post product_order_items_path(@product.id), params: new_item_hash
      }.must_change 'OrderItem.count', 1

      new_order_item = OrderItem.first
      new_order = Order.first
      cart_items = Order.find_by(id: session[:order][:id]).order_items

      expect(session[:order]).must_equal new_order
      expect(cart_items.length).must_equal 1
      expect(cart_items[0]).must_equal new_order_item
    end
  end

end