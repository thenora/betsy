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

  end

  def show

  end

  def update

  end

  def destroy

  end
end
