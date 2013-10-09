class UsersController < ApplicationController

  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    @capsule = Capsule.new
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "User Successfully Updated"
      redirect_to @user
    else
      flash[:error] = "Unable to Update User"
      render 'edit'
    end
  end
end
