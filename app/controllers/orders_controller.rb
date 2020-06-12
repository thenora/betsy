class OrdersController < ApplicationController

	#GET /orders
	def index
		@orders = Order.all
		#  order = Order.all.as_json(only: [:id, :card_number,:card_expiration_date, :card_cvv, :address, :city,:zip_code, :guest_name, :email, :phone_num, :cart_status])
		# render json: order, status: :ok
	end
		
	#GET /orders/:id
	def show
		order_id = params[:id].to_i
    @order = Order.find_by_id(order_id)
  
		if @order.nil?
			head :not_found
		return
		end
	end

	def cart # show function for the open order at the moment
		if session[:order]
			@cart_items = Order.find_by(id: session[:order][:id]).order_items
		end
	end

end

