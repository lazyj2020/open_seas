class SentController < ApplicationController
  
 def index
    @title = "Messaging System"
    @messages = current_user.sent_messages.paginate :per_page => 10, :page => params[:page], :order => "updated_at ASC"
  end

  def show
    @title = "Messages"
    @message = current_user.sent_messages.find(params[:id])
  end

  def new
    @title = "Compose Message"
    @message = current_user.sent_messages.build
  end
  
  def create
    @message = current_user.sent_messages.build(params[:message])

    if @message.save
      flash[:notice] = "Message sent."
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
  
end
