require "test_helper"

describe OrderItem do
  before do
    @order_item = OrderItem.new(name: "order_item1")
    @new_product = products(:product_1)
    @new_order = Order.create
    @valid_order_item = OrderItem.create!(name: @new_product.name, price: @new_product.price, quantity: @new_product.inventory, product_id: @new_product.id, order_id: @new_order.id)

  end
  
  describe "validations" do
    it "is valid when parameter are present" do
      expect(@valid_order_item.valid?).must_equal true
    end
    
    it "is invalid without a name" do
      invalid_order_item = order_items(:order_item1)
      invalid_order_item.name = nil
      invalid_order_item.save
      expect(invalid_order_item.valid?).must_equal false
      expect(invalid_order_item.errors.messages).must_include :name
      expect(invalid_order_item.errors.messages[:name]).must_equal ["can't be blank"]
    end

  end
  
  describe "relations" do
    it "belongs to one product" do
      @valid_order_item.save
      expect(@valid_order_item.product).must_be_instance_of Product
    end

    it "belongs to one order" do
      @valid_order_item.save
      expect(@valid_order_item.order).must_be_instance_of Order
    end
  end

  describe "update_product_inventory" do
    it "returns true if product inventory is adequate for updating cart" do
      expect(order_items(:order_item4).update_product_inventory(1)).must_equal true
    end

    it "returns false if product inventory is inadequate for updating cart" do
      expect(order_items(:order_item4).update_product_inventory(10)).must_equal false      
    end
  end
end

