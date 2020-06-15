class MerchantsController < ApplicationController

  def create
    auth_hash = request.env["omniauth.auth"]

    merchant = Merchant.find_by(uid: auth_hash[:uid], provider: "github")
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
    return redirect_to root_path
  end

  def dashboard
    @merchant = Merchant.find_by(id: session[:user_id], provider: "github")

    if @merchant.nil?
      flash[:error] = "You must be logged in to view this page!"
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
  end

  private

  def merchant_params
    return params.require(:merchant).permit(:username, :email, :uid, :provider)
  end

end
