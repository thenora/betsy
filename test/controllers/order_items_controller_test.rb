# frozen_string_literal: true

require 'test_helper'

describe OrderItemsController do
  before do
    @merchant = merchants(:merchant_1)
    @test_product1 = products(:product_1)
    @new_order = Order.create(
      card_number: 1234567890123456, 
      card_expiration_date: Date.today + 365, 
      card_cvv: 123,
      address: "15 Main Street", 
      city: "Seattle", 
      zip_code: 98010, 
      guest_name: "Tyron Jenkins", 
      email: "tyrone@gmail.com", 
      phone_num: "(456)123-1234"
    )
    @new_order1 = Order.create(
      card_number: 1234567890123457, 
      card_expiration_date: Date.today + 365, 
      card_cvv: 121,
      address: "151 Main Street", 
      city: "Seattle", 
      zip_code: 98011, 
      guest_name: "test_user1", 
      email: "test_user1@gmail.com", 
      phone_num: "(456)123-1235"
    )
    @new_order_item = OrderItem.create(
      name: @test_product1.name, 
      price: @test_product1.price, 
      quantity: 1, 
      product_id: @test_product1.id, 
      order_id: @new_order.id
    )

  end

  let (:new_item_hash) {
    {
      order_item: {
        name: @test_product1.name,
        price: @test_product1.price,
        quantity: 1,
        product_id: @test_product1.id
      }
    }
  }
  
  describe "index" do
    it "can get the index path" do
      get order_items_path
      must_respond_with :success
    end

    it "lists order items based on product id via nested routes" do
      get product_order_items_path(@test_product1.id)
      must_respond_with :success
      body = JSON.parse(response.body)
      expect(body.length).must_equal 1
      expect(body[0]["name"]).must_equal @test_product1.name
    end
  end

  describe "create" do
    it "can create a new OrderItem with valid information accurately, and redirect" do
      expect {
        post product_order_items_path(@test_product1.id), 
        params: new_item_hash
      }.must_change "Product.find(#{@test_product1.id}).order_items.count", 2
      

      found_order_item = OrderItem.find_by(order_id: session[:order_id])
      #new_order = Order.first

      expect(found_order_item.name).must_equal new_item_hash[:order_item][:name]
      expect(found_order_item.price).must_equal new_item_hash[:order_item][:price]
      expect(found_order_item.quantity).must_equal new_item_hash[:order_item][:quantity]
      expect(found_order_item.product_id).must_equal new_item_hash[:order_item][:product_id]
      expect(found_order_item.order_id).must_equal session[:order_id]

      must_redirect_to cart_path
    end

    it "does not create a new OrderItem if the form data violates inventory, and responds with a redirect" do
      new_item_hash[:order_item][:quantity] = 1000
      
      expect {
        post product_order_items_path(@test_product1.id), params: new_item_hash
      }.wont_change 'OrderItem.count'

      must_redirect_to root_path

    end
  end


  #KATE WILL FINISH UPDATE AND DESTOY TESTS WEDNESDAY!!!!!!!#


end
