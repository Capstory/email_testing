class CapsulesController < ApplicationController
  
  def create
    @capsule = Capsule.create(name: params[:capsule][:name])
    if @capsule.save
      @encapsulation = Encapsulation.create(user_id: params[:capsule][:user_id], capsule_id: @capsule.id, owner: true)
      if @encapsulation.save
        flash[:success] = "Capsule Successfully Create"
        redirect_to @encapsulation.user
      else
        flash[:error] = "Unable to Establish Encapsulation"
        redirect_to :back
      end
    else
      flash[:error] = "Unable to Create Capsule"
      redirect_to :back
    end
  end
  
  def show
    @capsule = Capsule.find(params[:id])
  end
end
