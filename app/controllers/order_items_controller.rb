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
			@order = Order.new()
	
	end

end
