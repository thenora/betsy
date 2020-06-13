require "test_helper"

describe ProductsController do
  let (:merchant_1) {
    merchants(:merchant_1)
  }    

  let (:product_1) {
    products(:product_1)
  }

  let (:inactive_product) {
    products(:product_3)
  }

  let (:product_hash) {
    {
      product: {
        name: "Monstera",
        price: 39.99,
        description: "Big green plant!",
        inventory: 3,
        merchant_id: merchant_1.id,
        status: true,
        photo_url: "https://bloomscape.com/wp-content/uploads/2019/11/bloomscape_peopleplants_monstera-scaled.jpg"
      }
    }
  }

  describe "index" do
    it "must get index" do
      get products_path
      must_respond_with :success
    end

    # TODO add doesn't display if status is set to false
  end

  describe "new" do
    # TODO require login
    it "gets the path" do
      get new_product_path
      must_respond_with :success
    end

    # TODO add if user id not logged in, then it redirects to the homepage
    # it "if not logged in, redirects to root path" do
    #   get new_product_path
      
    #   must_respond_with :redirect
    #   must_redirect_to root_path
    # end
  end


  describe "create" do

    # TODO - require login
    it "creates a new product" do

      # new_product = Product.new(product_hash)
      new_product = {
        product: {
          name: "A Really Big Monstera",
          price: 39.99,
          description: "Big green plant!",
          inventory: 3,
          merchant_id: merchant_1.id,
          status: true,
          photo_url: "https://bloomscape.com/wp-content/uploads/2019/11/bloomscape_peopleplants_monstera-scaled.jpg"
        }
      }



      expect {
        #post products_path, params: product_hash
        post products_path, params: new_product
      }.must_differ 'Product.count', 1

      # must_respond_with :redirect
      # must_redirect_to product_path(Product.last.id)
      # expect(Product.last.name).must_equal product_hash[:product][:name]
      # expect(Product.last.price).must_equal product_hash[:product][:price]
      # expect(Product.last.description).must_equal product_hash[:product][:description]
      # expect(Product.last.inventory).must_equal product_hash[:product][:inventory]
      # expect(Product.merchant_id).must_equal product_hash[:product][:merchant_id]
    end

    # TODO add after validations
    # it "doesn't create a product with invalid data" do
    #   product_hash[:product][:name] = nil

    #   expect {
    #     post products_path, params: product_hash
    #   }.must_differ "Product.count", 0

    #   must_respond_with :bad_request
    # end

    # TODO add not logged in redirect to root path
    # it "if users is not logged in, redirects to homepage" do       
    #   expect{ post products_path, params: product_hash }.must_differ 'Product.count', 0
      
    #   must_respond_with :redirect
    #   must_redirect_to root_path
    # end    
  end

  describe "show" do
    it "will get show for valid ids" do
      # Arrange
      valid_product_id = product_1.id
  
      # Act
      get "/products/#{valid_product_id}"
  
      # Assert
      must_respond_with :success
    end

    it "will respond with not_found for invalid ids" do
      # Arrange
      invalid_product_id = 999
  
      # Act
      get "/products/#{invalid_product_id}"
  
      # Assert
      must_respond_with :not_found
    end

    # TODO add cannot view product with status set to false
  end

  describe "update" do

    # TODO require login
    it "will update a product with a valid post request and redirect" do
      id = Product.first.id
      expect {
        patch product_path(id), params: product_hash
      }.wont_change "Product.count"
  
      must_respond_with :redirect
      must_redirect_to product_path(id)
  
      product = Product.find_by(id: id)
      expect(product.name).must_equal product_hash[:product][:name]
      expect(product.description).must_equal product_hash[:product][:description]
    end
  
    # TODO require login
    it "will respond with not_found for invalid ids" do
      id = -1
  
      expect {
        patch product_path(id), params: product_hash
      }.wont_change "Product.count"
  
      must_respond_with :not_found
    end
  
    # TODO after validations are added
    # TODO require login
    # it "will not update if the params are invalid" do
    #   product_hash[:product][:name] = nil

    #   expect {
    #     patch product_path(product_1.id), params: product_hash
    #   }.wont_change "Product.count"

    #   product_1.reload # refresh the product from the database
    #   must_respond_with :bad_request
    #   expect(product.name).wont_be_nil
    # end

    # TODO Add not logged in version
    # it "will not change a product if not logged in" do
    #   id = Product.first.id
    #   name = Product.first.name
    #   expect {
    #     patch product_path(id), params: product_hash
    #   }.wont_change "Product.count"
  
    #   must_respond_with :redirect
    #   must_redirect_to root_path
  
    #   product = Product.find_by(id: id)
    #   expect(product.name).must_equal name
    # end
  end
end
