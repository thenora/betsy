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

	# PATCH:  /order_items/:id (params)
	def update
		@order_item = OrderItem.find_by(id: params[:id])
		if @order_item.nil?
			head :not_found
			return
		elsif @order_item.update(order_items_params)
			redirect_to order_path(@order_item.order.id) # /orders/:id
			return
		else
			flash[:failure] = 'Order item could not be updated.'
			redirect_to order_path(@order_item.order.id) #/orders/:id
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
		@order_item.destroy
		# redirect_to order_path(@order_item.order.id)

		#check if order items have a count of 0, then delete order
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

end

private

def order_items_params
  return params.require(:order_item).permit(:name, :price, :quantity, :product_id, :order_id)
end