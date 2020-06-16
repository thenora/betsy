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

	def update
		@open_order = Order.find_by(cart_status: true)

		if @open_order.nil?
			head :not_found
			return
		elsif @open_order.update(orders_params)
			redirect_to confirmation_path
      return
		else
			flash[:error] = 'Order could not be placed.'
			redirect_to checkout_path
      return
    end
	end

	def cart # show function for the open order at the moment
		if !session[:order].nil?
			@open_order = Order.find_by(cart_status: true)
			p @open_order
		end

		if !@open_order.nil?
			@cart_items = @open_order.order_items
		end
	end

	def checkout
		@cart = Order.find_by(cart_status: true)

		if @cart.nil? || @cart.order_items.length == 0		
			flash[:failure] = "Unable to checkout."
			redirect_to cart_path
      return
		end
		
		head :ok
		@cart_items = @cart.order_items
	end

	def confirmation
		@cart = Order.find_by(cart_status: true)

		if @cart.nil? || @cart.order_items.length == 0
			flash[:error] = "Unable to checkout."
			render :update
			return
		end

		head :ok

		@cart_items = @cart.order_items

		Order.purchase_changes(@cart, @cart_items)

		session[:order] = nil
	end

	private

	def orders_params
		return params.require(:order).permit(:guest_name, :email, :phone_num, :address, :city, :state, :zip_code, :card_number, :card_expiration_date, :card_cvv)
	end

end

