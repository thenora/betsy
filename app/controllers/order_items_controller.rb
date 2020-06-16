class OrderItemsController < ApplicationController
	skip_before_action :verify_authenticity_token
	#database order_items -> use OrderItem
	#GET /order_items
	def index
		order_items = OrderItem.all.as_json(only: [:id, :name, :price, :quantity])
		render json: order_items, status: :ok
	end
	
	#POST /order_items  { :order_item => { :name => "hello", :price => 6, }}
	def create
		if session[:order]
			@open_order = Order.find_by(cart_status: true)
			@new_item = OrderItem.new(
				name: order_items_params[:name],
				price: order_items_params[:price],
				quantity: order_items_params[:quantity],
				product_id: params[:product_id],
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
				product_id: params[:product_id],
				photo_url: order_items_params[:photo_url],
				order_id: @new_order.id
			)

			p "CREATE A SESSION"
		end

		if @new_item.save && @new_item.check_product_inventory
			@new_item.reduce_inventory
			p "ITEM WAS ADD"
			flash[:success] = 'Item added to cart.'
			redirect_to cart_path
			return
		else
			p "ITEM WAS not ADDED"
			flash[:failure] = 'Not enough product inventory.'
			redirect_back fallback_location: root_path
			return
		end
	end

	# PATCH:  /order_items/:id (params)
	def update
		@order_item = OrderItem.find_by(id: params[:id])
		if @order_item.nil?
			head :not_found
			return
		elsif @order_item.update(order_items_params) && @order_item.check_product_inventory
			flash[:success] = 'Order item quantity updated.'
			redirect_to cart_path
			return
		else
			flash[:failure] = 'Not enough inventory to update quantity.'
			redirect_to cart_path
			return
		end
	end

	# DElETE  /order_items/:id
	def destroy
		@order_item = OrderItem.find_by(id: params[:id])

		if @order_item.nil?
			head :not_found
			return
		end

		@order_item.add_inventory
		@order_item.destroy

		#check if order items have a count of 0, then delete order
		count = @order_item.order.order_items.count

		if count == 0
			@order_item.order.destroy
			session[:order] = nil
		end

		redirect_to cart_path
		return
	end

	private

	def order_items_params
		return params.require(:order_item).permit(:name, :price, :quantity, :photo_url, :product_id, :order_id)
	end

end