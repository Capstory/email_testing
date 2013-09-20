class EmailRetrieversController < ApplicationController
  def activate
    email = EmailRetriever.new
    if email.start
      redirect_to :back
    else
      redirect_to :back
    end
  end
end
