require "test_helper"

describe Order do
  before do

    @new_order = Order.new(card_number: 1234567890123456, card_expiration_date: Date.today + 365, card_cvv: '123',
      address: "15 Main Street", city: "Seattle", state: 'wa', zip_code: '98010', guest_name: "Tyron Jenkins", email: "tyrone@gmail.com", phone_num: "(456)123-1234", cart_status: false)
    
    @product_1 = products(:product_1)
    @new_product1 = Product.create(name: @product_1.name, price: @product_1.price, inventory: @product_1.inventory)
    
    @order1 = orders(:order1)

    @new_order_item = OrderItem.create(product: @new_product, order: @new_order)    
  end

  describe "relations" do
    it "has many order items" do
      expect(@new_order).must_respond_to :order_items
    end
    it "has many products" do
      expect(@new_order).must_respond_to :products
    end
  end
 
  describe "validations" do
    it "is valid when parameters are present" do
      expect(@new_order.valid?).must_equal true
      expect(@new_order.guest_name).must_equal @order1.guest_name
    end

    it "is invalid without a card number" do
      expect(@new_order.valid?).must_equal true #check order valid
      expect(@new_order.card_number.length).must_equal 16
      @new_order.update(card_number: nil) #make sure number nil
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid with an invalid card number" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(card_number: 1234 )
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid without a card expiration date" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(card_expiration_date: nil)
      assert_nil(@new_order.card_expiration_date)
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid without a card cvv" do
      expect(@new_order.valid?).must_equal true
      expect(@new_order.card_cvv.length).must_equal 3
      @new_order.update(card_cvv: nil)
      assert_nil(@new_order.card_cvv) 
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid with an invalid cvv" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(card_cvv: 1234 )
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid without an address" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(address: nil)
      assert_nil(@new_order.address)
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid without a city" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(city: nil)
      assert_nil(@new_order.city)
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid without a state" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(city: nil)
      assert_nil(@new_order.city)
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid without a zip code" do
      expect(@new_order.valid?).must_equal true
      expect(@new_order.zip_code.length).must_equal 5
      @new_order.update(zip_code: nil)
      assert_nil(@new_order.zip_code)
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid with an invalid zip code" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(zip_code: 1234 )
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid without a guest name" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(guest_name: nil)
      assert_nil(@new_order.guest_name)
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid without an email" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(email: nil)
      assert_nil(@new_order.email)
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid with an invalid email" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(email: "1234 @ gmail com"  )
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid without a phone number" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(phone_num: nil)
      assert_nil(@new_order.phone_num)
      expect(@new_order.valid?).must_equal false
    end

    it "is invalid with an invalid phone number" do
      expect(@new_order.valid?).must_equal true
      @new_order.update(phone_num: "123.234.1234" )
      expect(@new_order.valid?).must_equal false
    end

  end
  
  describe "total price" do
    it "calculates the order total correctly" do
      @price_order = orders(:order1)
      expect(@price_order.valid?).must_equal true
      expect(@price_order.total_price).must_equal 0.0
    end
  end

  # describe "purchase changes" do
  #   it "change cart status?" do
  #     TODO
  #   end
  # end

end #Order
