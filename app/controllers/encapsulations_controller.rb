class EncapsulationsController < ApplicationController
  
  # =====================================
  # Begin standard controller actions
  # =====================================

  def new
    @users = User.all
    @capsules = Capsule.all
    @encap = Encapsulation.new
  end
  
  def create
    @encap = Encapsulation.create(params[:encapsulation])
    if @encap.save
      flash[:success] = "Connection Created"
      redirect_to dashboard_path
    else
      flash[:error] = "Unable to Create Encapsulation"
      render 'new'
    end
  end
  
  def destroy
    encap = Encapsulation.find(params[:id])
    encap.delete
    flash[:success] = "Encapsulation successfully deleted"
    redirect_to :back
  end
  
  
  # =====================================
  # Begin non-standard controller actions
  # =====================================
  
end