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

    def create
        @order = Order.new()
    
    end
end

