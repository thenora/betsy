class OrderItemsController < ApplicationController

	# def index
	# 	@order_items = order_items.all
	# end
		
	# def show
	# 	if @order_item.nil?
	# 		head :not_found
	# 		return
	# 	end
	# end

	def create
		
		if session[:order]
			@open_order = Order.find_by(id: session[:order][:id])

		else
			new_order = Order.new
			session[:order] = new_order

			

			# maybe have an array of order_item ids within Order.
			# or an array of order_item Objects
		end
	
	end

end
