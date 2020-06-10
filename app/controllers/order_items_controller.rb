class OrderItemsController < ApplicationController

	# def index
	# 	@order_items = order_items.all
	# end
		
	# def show
	# 	@order_item = Order.find_by(id: params[:id])
	# 	flash[:success] = 'Item added to cart.'
	# 	if @order_item.nil?
	# 		flash.now[:error] = 'Item could not be added.'
	# 		redirect_to product_order_items_path(params[:product_id])
	# 		#render :new, status: :bad_request
	# 		#head :not_found
	# 		return
	# 	end
	# end

	

	#ADD TO CART products/:product_id/order_items
	def create
		if session[:order]
			@open_order = Order.find_by(id: session[:order][:id])
			@new_item = OrderItem.new(
				name: params[:order_item][:name],
				price: params[:order_item][:price],
				quantity: params[:order_item][:quantity],
				product_id: params[:product_id],
				order_id: @open_order.id
			)
		else
			@new_order = Order.create
			session[:order] = @new_order

			@new_item = OrderItem.new(
				name: params[:order_item][:name],
				price: params[:order_item][:price],
				quantity: params[:order_item][:quantity],
				product_id: params[:product_id],
				order_id: @new_order.id
			)
		end

		if @new_item.save
			flash[:success] = 'Item added to cart.'
			redirect_to orders_path
			return
		else
			flash[:failure] = 'Item could not be added.'
			redirect_to product_order_items_path(params[:product_id])
			# redirect_back fallback_location: root_path
			return
		end
	end

	#PATCH: UPDATE CART /orders/:id (params)
	# def update
	# 	@order_item = Vote.find_by(id: params[:id])
	# 	if @order_item.nil?
	# 		head :not_found
	# 		return
	# 	elsif @order_item.update(order_item_params)
			
	# 		redirect_to orders_path
	# 		return
	# 	else
	# 		render :edit
	# 		return
	# 	end
	# end

	#REMOVE FROM CART /orders/:id
	# def destroy
	# 	@order_item = Order.find_by(id: params[:id])
	# 	if @order_item.nil?
	# 		head :not_found
	# 		return
	# 	end
  
  # 	@order_item.destroy
  
  # 	redirect_to orders_path
  # 	return
	# end

end

def order_items_params
  return params.require(:order_item).permit(:name, :price, :quantity, :product_id, :order_id)
end