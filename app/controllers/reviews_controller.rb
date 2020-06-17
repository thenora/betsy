class ReviewsController < ApplicationController

	skip_before_action :verify_authenticity_token
	skip_before_action :require_login

  def create
		@review = Review.new(
			title: review_params[:title],
			rating: review_params[:rating],
			description: review_params[:description],
			product_id: params[:product_id]
		)
		
		if @review.save && (session[:user_id] != params[:merchant_id])
			flash[:success] = "Your review was added."
		elsif (session[:user_id] == params[:merchant_id])
			flash.now[:failure] = "You cannot review your own product."
		else
			flash.now[:failure] = "Error: Review could not be added."
		end

		redirect_back fallback_location: root_path
		return
	end
	
	private

	def review_params
		return params.require(:review).permit(:title, :rating, :description, :product_id, :merchant_id)
	end
end
