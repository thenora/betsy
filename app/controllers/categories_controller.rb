class CategoriesController < ApplicationController
  # skip_before_action :require_login, only: [:index, :show]
  # TODO add require login for everything but index and show

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find_by(id: params[:id]) # TODO make controller fixture
    if @category.nil?
      head :not_found
      return
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new( category_params )
    if @category.save
      flash[:success] = "#{@category.name} added."
      redirect_to categories_path
    else
      flash.now[:error] = "Oops. We couldn't add your category."
      render :new, status: :bad_request
    end
  end

  def edit
    @category = Category.find_by(id: params[:id] )
    if @category.nil?
      flash[:error] = "Oops. Couldn't find that category."
      redirect_to categories_path
      return
    end
  end

  def update
    @category = Category.find_by(id: params[:id] )
    if @category.nil?
      flash[:error] = "Oops. Couldn't find that category."
      redirect_to categories_path
      return
    elsif @category.update( category_params )
      flash[:success] = "#{@category.name} updated."
      redirect_to category_path(@category.id)
    else
      flash.now[:error] = "#{@category.name} wasn't updated."
      render :edit, status: :bad_request
    end
  end

  private             
  
  def category_params
    return params.require(:category).permit(:name)
  end
end
