class ReviewsController < ApplicationController

	def index
		product = Product.find_by(id: params[:product_id])
		
	end
end
