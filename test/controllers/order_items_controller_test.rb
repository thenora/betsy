require "test_helper"

describe OrderItemsController do
  before do
    @merchant = Merchant.create(
      username: 'test_user',
      email: 'test_user@gmail.com'
    )
    @test_product1 = Product.create(
      name: 'test product1', 
      price: 5.00, 
      description: 'This is a fake plant.',
      inventory: 5,
      merchant_id: @merchant.id
    )
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


  # describe "update" do
  #   before do
  #     @driver = Driver.create(name: 'Leroy Jenkins', vin: 'SU9PYDRK6214WL15M', available: true)
  #     @passenger = Passenger.create(name: "test person", phone_num: "1234567")
  #     @trip = Trip.create(
  #       passenger_id: @passenger.id,
  #       driver_id: @driver.id,
  #       date: Date.today,
  #       rating: nil,
  #       cost: rand(1...3000)
  #     )
  #   end

  #   let (:update_hash) {
  #     {
  #       trip: {
  #         rating: 2
  #       }
  #     }
  #   }

  #   it "can update an existing trip with valid information accurately, and redirect" do
  #     expect {
  #       patch trip_path(@trip.id), params: update_hash
  #     }.wont_change 'Trip.count'

  #     must_redirect_to trip_path(@trip.id)

  #     find_trip = Trip.find_by(id: @trip.id)
  #     expect(find_trip.rating).must_equal update_hash[:trip][:rating]
  #   end

  #   it "does not update any trip if given an invalid id, and responds with a 404" do
  #     expect {
  #       patch trip_path(-1), params: update_hash
  #     }.wont_change 'Trip.count'

  #     must_respond_with :not_found
  #   end

  #   it "does not update a Trip if the form data violates Driver validations, and responds with a redirect" do
  #     update_trip = {
  #       trip: {
  #         rating: 8
  #       }
  #     }

  #     expect {
  #       patch trip_path(@trip.id), params: update_trip
  #     }.wont_change 'Trip.count'

  #     must_respond_with :redirect
  #   end
  # end

  # describe "destroy" do
  #   it "destroys the Trip instance in db when Trip exists, then redirects" do
  #     driver = Driver.create(name: 'Leroy Jenkins', vin: 'SU9PYDRK6214WL15M', available: true)
  #     passenger = Passenger.create(name: "test person", phone_num: "1234567")
  #     trip = Trip.create(
  #       passenger_id: passenger.id,
  #       driver_id: driver.id,
  #       date: Date.today,
  #       rating: nil,
  #       cost: rand(1...3000)
  #     )

  #     expect {
  #       delete trip_path(trip.id)
  #     }.must_differ 'Trip.count', -1

  #     must_respond_with :redirect
  #     must_redirect_to root_path
  #   end

  #   it "does not change the db when the Trip does not exist, then responds with redirect" do
  #     expect {
  #       delete trip_path(-1)
  #     }.wont_change 'Driver.count'

  #     must_respond_with :not_found
  #   end
  # end


  # describe "destroy" do
  #   it "destroys the order item instance in db when order item exists, then redirects" do
  #     new_order_item = Order.create(name: 'Tyron Banks', price: 2, quantity: 30, product_id: @product.id, merchant_id: @merchant.id)

  #     expect {
  #       delete orders_path(id: new_trip.id)
  #     }.must_differ 'Trip.count', -1
      
  #     deleted = Trip.find_by(id: new_trip.id)
  #     expect(deleted).must_be_nil
      
  #     must_redirect_to trips_path
  #   end
  #   it "does not change the db when the driver does not exist, then responds with " do
  #     expect {
  #       delete trip_path(id: -1)
  #     }.must_differ 'Trip.count', 0
  #   end
  # end

end
