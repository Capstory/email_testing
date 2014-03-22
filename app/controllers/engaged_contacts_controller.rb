class EngagedContactsController < ApplicationController
  layout "homepage_blank"
  
  def new
    @engaged_contact = EngagedContact.new
  end
  
  def create
    @engaged_contact = EngagedContact.create(params[:engaged_contact])
    if @engaged_contact.save
      EngagedContactMailer.tell_an_engaged_friend(@engaged_contact).deliver
      redirect_to engaged_contact_thank_you_path(engaged_contact_id: @engaged_contact.id)
    else
      flash[:error] = "There was a problem. Please try again."
      render 'new'
    end
  end
  
  def thank_you
    @engaged_contact = EngagedContact.find(params[:engaged_contact_id])
  end
end
