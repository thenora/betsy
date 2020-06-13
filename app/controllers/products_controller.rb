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
    @product.merchant_id = session[:user_id]

    if @product.save
      flash[:success] = "Your product was added."
      redirect_to product_path(@product.id)
      return
    else # if save fails
      flash.now[:error] = "Oops. We couldn't add your product because #{@product.errors.full_messages}."
      render :new, status: :bad_request # show the new media form again
      return
    end
  end

  def show
    @product = Product.find_by(id: params[:id]) # TODO make controller fixture
    if @product.nil?
      head :not_found
      return
    end
  end

  def edit
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      head :not_found
      return
    end
    # TODO add session id must match product merchant id
    if @product.merchant_id != session[:user_id]
      flash[:error] = "Oops. You can only edit your own products."
      redirect_to product_path(@product.id)
      return
    end

  end

  def update
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      head :not_found
      return
    elsif @product.update(product_params)
      flash[:success] = "Product updated!"
      redirect_to product_path(@product.id) 
      return
    else # save failed
      flash.now[:error] = "Oops! We couldn't update your product."
      render :edit, status: :bad_request # show the new media form view again
      return
    end
  end

  def destroy
    # TODO do we need this?
  end

  private

  def product_params
    return params.require(:product).permit(
      :name, 
      :price, 
      :description, 
      :inventory, 
      :status, 
      :photo_url,
      category_ids: []
    )
  end
end
