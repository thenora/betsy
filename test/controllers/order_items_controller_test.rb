# frozen_string_literal: true

require 'test_helper'

describe OrderItemsController do
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

  let (:new_item_hash) do
    {
      order_item: {
        name: @product.name,
        price: @product.price,
        quantity: 1,
        product_id: @product.id
      }
    }
  end

  describe 'create' do
    it 'can create a new OrderItem with valid information accurately, and redirect' do
      expect do
        post product_order_items_path(@product.id), params: new_item_hash
      end.must_change 'OrderItem.count', 1

      new_order_item = OrderItem.find_by(name: @product.name)

      expect(new_order_item.name).must_equal @product.name
      expect(new_order_item.price).must_equal @product.price
      expect(new_order_item.quantity).must_equal 1
      expect(new_order_item.product_id).must_equal @product.id

      must_redirect_to orders_path
    end

    it 'does not create a new OrderItem if the form data violates validations, and responds with a redirect' do
      new_item_hash[:order_item][:name] = nil

      expect do
        post product_order_items_path(@product.id), params: new_item_hash
      end.wont_change 'OrderItem.count'

      must_redirect_to product_order_items_path(@product.id)
    end
  end

  # describe "edit" do
  #   before do
  #     @driver = Driver.create(name: 'Leroy Jenkins', vin: 'SU9PYDRK6214WL15M', available: true)
  #     @passenger = Passenger.create(name: "test person", phone_num: "1234567")
  #   end

  #   it "responds with success when getting the edit page for an existing, valid trip" do
  #     trip = Trip.create(
  #       passenger_id: @passenger.id,
  #       driver_id: @driver.id,
  #       date: Date.today,
  #       rating: nil,
  #       cost: rand(1...3000)
  #     )

  #     get edit_trip_path(trip.id)

  #     must_respond_with :success
  #   end

  #   it "responds with redirect when getting the edit page for a non-existing trip" do
  #     get edit_trip_path(-1)

  #     must_respond_with :not_found
  #   end
  # end

  describe 'edit' do
    it 'responds with success when getting the edit page for an existing, valid order' do
      get edit_orders_path(trip)
      must_respond_with :success
    end

    it 'responds with redirect when getting the edit page for a non-existing order item' do
      get edit_orders_path(-1)
      must_redirect_to orders_path
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
