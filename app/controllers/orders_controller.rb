class OrdersController < ApplicationController

	#TODO: 

	#all orders
	# def index
	# 	@order = Order.all
	# end
		

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
		if session[:order]
			@cart_items = Order.find_by(id: session[:order]["id"]).order_items
		end
	end

end

