class OrderItemsController < ApplicationController
	
	#POST /order_items  { :order_item => { :name => "hello", :price => 6, }}
	def create
		if session[:order]
			@open_order = Order.find_by(id: session[:order]["id"])
			@new_item = OrderItem.new(
				name: order_items_params[:name],
				price: order_items_params[:price],
				quantity: order_items_params[:quantity],
				product_id: order_items_params[:product_id],
				photo_url: order_items_params[:photo_url],
				order_id: @open_order.id
			)

			p "SESSION IS HERE"
		else
			@new_order = Order.create
			session[:order] = @new_order
			
			@new_item = OrderItem.new(
				name: order_items_params[:name],
				price: order_items_params[:price],
				quantity: order_items_params[:quantity],
				product_id: order_items_params[:product_id],
				photo_url: order_items_params[:photo_url],
				order_id: @new_order.id
			)

			p "CREATE A SESSION"
		end

		if @new_item.save
			p "ITEM WAS ADD"
			flash[:success] = 'Item added to cart.'
			redirect_to cart_path
			return
		else
			p "ITEM WAS not ADDED"
			flash[:failure] = 'Item could not be added.'
			redirect_to product_order_items_path(params[:product_id])
			# redirect_back fallback_location: root_path
			return
		end
	end

	# PATCH:  /order_items/:id (params)
	def update
		@order_item = Order_item.find_by(id: params[:id])
		if @order_item.nil?
			head :not_found
			return
		elsif @order_item.update(order_item_params)
			redirect_to orders_path # /orders
			return
		else
			flash[:failure] = 'Order item could not be updated.'
			redirect_to order_path(@order_item.order.id) #/orders/:id
			return
		end
	end

	# DElETE  /order_items/:id
	def destroy
		@order_item = Order_item.find_by(id: params[:id])
		if @order_item.nil?
			head :not_found
			return
		end
  
		@order_item.destroy
		count = @order_item.order.order_items.count
		if count == 0
			@order_item.order.destroy
			redirect_to orders_path # /orders
			return
		else
			redirect_to order_path(@order_item.order.id) #/orders/:id
			return
		end
	end

	def order_items_params
		return params.require(:order_item).permit(:name, :price, :quantity, :photo_url, :product_id, :order_id)
	end
end