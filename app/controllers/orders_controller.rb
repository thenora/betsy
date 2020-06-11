class OrdersController < ApplicationController

	#TODO: 

	#all orders
	def index
		@order = orders.all
	end
		

	#individual order
	def show
		if @order.nil?
			head :not_found
			return
		end
	end

	#mark order sent or closed
	def delete
		
	end



	def cart # show function for the open order at the moment
		# session[:order][:id]
	end

end

