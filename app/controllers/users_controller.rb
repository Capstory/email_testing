class UsersController < ApplicationController

  def index
    @users = User.all
  end
  
  def welcome
		if current_user
			redirect_to current_user
		else
			flash[:error] = "Please log in"
			redirect_to login_path
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
  
  def destroy
    user = User.find(params[:id])
    if current_user.id == user.id
      flash[:error] = "You can't delete yourself"
      redirect_to :back
    else
      user.delete
      redirect_to users_path  
    end
  end
end
