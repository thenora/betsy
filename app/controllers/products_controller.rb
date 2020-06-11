class ProductsController < ApplicationController
  # TODO setup login required
  # skip_before_action :require_login, only: [:index, :show]

  def index
    @products = Product.all
    # TODO add status active
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params) # Instantiate a new work
    # TODO add merchant
    # @product.merchant_id = session[:merchant_id]

    if @product.save
      flash[:success] = "Your product was added."
      redirect_to product_path(@product.id)
      return
    else # if save fails
      flash.now[:error] = "Oops. We couldn't add your product."
      render :new, status: :bad_request # show the new media form again
      return
    end
  end

  def show

  end

  def update

  end

  def destroy

  end

  private

  def product_params
    return params.require(:product).permit(:name, :price, :description, :inventory, :status, :photo_url)
  end
end
