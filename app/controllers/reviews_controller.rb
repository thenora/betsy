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
		
		if @review.save!
			flash[:success] = "Your review was added."
			redirect_back fallback_location: root_path
			return
		else
			flash.now[:failure] = "Error: Review could not be added."
			redirect_back fallback_location: root_path
			return
		end
	end
	
	private

	def review_params
		return params.require(:review).permit(:title, :rating, :description, :product_id)
	end
end
