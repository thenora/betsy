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
			@new_item = Order_Item.new(
				product_id: params[:product_id],
				order_id: @open_order.id
			)
		else
			@new_order = Order.new
			session[:order] = new_order

			@new_item = Order_Item.new(
				product_id: params[:product_id],
				order_id: @new_order.id
			)
		end
	
	end

end
