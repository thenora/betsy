class OrderItemsController < ApplicationController
	skip_before_action :verify_authenticity_token
	skip_before_action :require_login

	#database order_items -> use OrderItem
	#GET /order_items
	def index
		if params[:product_id]
      # This is the nested route, /products/:product_id/order_items
      product = Product.find_by(id: params[:product_id])
			order_items = product.order_items.as_json(only: [:id, :name, :price, :quantity])
			render json: order_items, status: :ok
    else
      # This is the 'regular' route, /order_items
      order_items = OrderItem.all.as_json(only: [:id, :name, :price, :quantity])
			render json: order_items, status: :ok
		end
	end
	
	#POST /order_items  { :order_item => { :name => "hello", :price => 6, }}
	def create
		if session[:order_id]
			@open_order = Order.find_by(id: session[:order_id])
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
			session[:order_id] = @new_order.id
			
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

		if @new_item.check_product_inventory
			@new_item.check_order_item_existence(session[:order_id])
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

		p params
		if @order_item.nil?
			head :not_found
			return
		elsif @order_item.update_product_inventory(order_items_params[:quantity])
			p "herereee?"
			@order_item.update(order_items_params)
			flash[:success] = 'Order item quantity updated.'
			redirect_to cart_path
			return
		else
			p "here?"
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
			session[:order_id] = nil
		end

		redirect_to cart_path
		return
	end

	private

	def order_items_params
		return params.require(:order_item).permit(:name, :price, :quantity, :photo_url, :product_id, :order_id)
	end

end