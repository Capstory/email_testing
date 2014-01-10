class AdminsController < ApplicationController

  def new
    @user = params[:id] ? User.find(params[:id]) : nil
    @admin = Admin.new
  end
  
  def create
    @admin = Admin.new
    @admin.name = params[:admin][:name]
    @admin.email = params[:admin][:email]
    @user_id = params[:admin][:user_id]
    if @admin.save
      transfer_capsule(@user_id, @admin.id)
      transfer_authorization(@user_id, @admin.id)
      relogin(@admin.id) if current_user.id = @user_id
      delete_old_user(@user_id)
      flash[:success] = "Admin successfully created"
      redirect_to users_path
    else
      flash[:error] = "Unable to create admin"
      render 'new'
    end
  end
  
  def show
    @admin = Admin.find(params[:id])
    redirect_to @admin.capsules.first
  end
  
  # I need to refactor all of these method below
  # The delete old user method is nothing other than a call to users#destroy
  # The transfer capsule method is nothing other than a call to capsules#update
  # The transfer authorization is nothing other than a call to authorizations#update
  # relogin is nothing other than a call to sessions#update
  # All of this is repeating code. NO REASON TO DO IT!!
  
  def delete_old_user(user_id = nil)
    unless user_id.nil?
      user = User.find(user_id)
      user.delete
    end
  end
  
  def transfer_capsule(user_id = nil, admin_id)
    unless user_id.nil?
      user = User.find(user_id)
      user.encapsulations.each do |encap|
        encap.user_id = admin_id
        encap.save
      end
    end
  end
  
  def transfer_authorization(user_id = nil, admin_id)
    unless user_id.nil?
      user = User.find(user_id)
      user.authorizations.each do |auth|
        auth.user_id = admin_id
        auth.save
      end
    end
  end

  def relogin(admin_id)
    session[:user_id] = nil
    session[:user_id] = admin_id
  end
end