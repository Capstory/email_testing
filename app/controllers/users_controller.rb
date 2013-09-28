class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    @capsule = Capsule.new
  end
end
