class OrdersController < ApplicationController

	def index
		@order = orders.all
	end
		

	def show
		if @order.nil?
			head :not_found
			return
		end
	end

	def cart # show function for the open order at the moment
		# session[:order][:id]
	end

end

