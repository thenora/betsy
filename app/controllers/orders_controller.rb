class OrdersController < ApplicationController

	def index
		@order = Order.all
	end
		

	def show
		if @order.nil?
			head :not_found
			return
		end
	end

	def cart # show function for the open order at the moment
		if session[:order]
			@open_order = Order.find_by(id: session[:order][:id])
		end
	end

end

