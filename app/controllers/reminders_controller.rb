class RemindersController < ApplicationController
  before_filter :admin_authentication, only: [:index, :edit, :destroy]
  
  def index
    @reminders = Reminder.all
  end

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = Reminder.create(params[:reminder])
    @reminder.reminder_sent = false
    if @reminder.save
      ReminderMailer.reminder_confirmation(@reminder).deliver
      redirect_to reminder_thank_you_path(email: @reminder.email)
    else
      flash[:error] = "Sorry there was a problem. Please, try again."
      redirect_to new_reminder_path
    end
  end
  
  def edit
    @reminder = Reminder.find(params[:id])
  end
  
  def update
    @reminder = Reminder.find(params[:id])
    if @reminder.update_attributes(params[:reminder])
      flash[:success] = "Reminder Successfully Updated"
      redirect_to reminders_path
    else
      flash[:error] = "Unable to update record"
      render "new"
    end
  end
  
  def destroy
    reminder = Reminder.find(params[:id])
    reminder.delete
    flash[:success] = "Reminder succesfully deleted"
    redirect_to :back
  end
  
  def thank_you
    @email = params[:email]
  end
end
