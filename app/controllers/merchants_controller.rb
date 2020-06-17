# frozen_string_literal: true

class MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil?
      head :not_found
      return
    end
  end

  def create
    auth_hash = request.env['omniauth.auth']

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: 'github')
    if merchant
      flash[:success] = "Logged in as returning merchant #{merchant.username}"
    else
      merchant = Merchant.build_from_github(auth_hash)

      if merchant.save
        flash[:success] = "Logged in as new merchant #{merchant.username}"
      else
        flash[:error] = "Could not create new merchant account: #{merchant.errors.messages}"
        return redirect_to root_path
      end
    end

    session[:user_id] = merchant.id
    redirect_to root_path
  end

  def dashboard
    @merchant = Merchant.find_by(id: session[:user_id], provider: 'github')
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'Successfully logged out!'

    redirect_to root_path
  end

  private

  def category_params
    params.require(:merchant).permit(:username, :email, :uid, :provider)
  end
end
