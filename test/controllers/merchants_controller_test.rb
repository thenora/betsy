require "test_helper"

describe MerchantsController do


  before do
    @merchant = Merchant.create()
    @order = Order.create()
  end

  let (:merchant_hash) {
    {
      merchant: {
        username: "username",
        email: "test@test.com",
        uid: 1,
        provider: "github"
      }
    }
  }

  describe "create" do

  end

  describe "show" do

  end

  describe "login/authorize with github" do
    
  end

end
