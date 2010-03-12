class MessagesController < ApplicationController
  include ApplicationHelper

  before_filter     :protect
  # GET /messages
  # GET /messages.xml
  def index
    @title = "Messenger"
     
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = current_user.received_messages.find(params[:id])
    @message.update_attribute("read", true)
  end
  
  def destroy
    @message = current_user.received_messages.find(params[:id])
    @message.destroy
    redirect_to :controller => "mailbox", :action => "index" 
  end
  
  def reply
    @original = current_user.received_messages.find(params[:id])
    
    subject = @original.subject.sub(/^/, "Re: ")
    body = @original.body.gsub(/^/, "> ")
    body = body + "\n"
    @message = current_user.sent_messages.build(:to => [@original.author.id], :subject => subject, :body => body)
    render :template => "sent/new"
  end

 def forward
    @original = current_user.received_messages.find(params[:id])
    
    subject = @original.subject.sub(/^/, "Fwd: ")
    body = @original.body.gsub(/^/, "> ")
    body = body + "\n"
    @message = current_user.sent_messages.build(:subject => subject, :body => body)
    render :template => "sent/new"
  end
  
  def reply_all
    @original = current_user.received_messages.find(params[:id])
    
    subject = @original.subject.sub(/^/, "Re: ")
    body = @original.body.gsub(/^/, "> ")
    body = body + "\n"
    recipients = @original.recipients.map(&:id) - [current_user.id] + [@original.author.id] 
    @message = current_user.sent_messages.build(:to => recipients, :subject => subject, :body => body)
    render :template => "sent/new"
  end
private

  # Protect a page from unauthorized access.


  def protect
     unless logged_in?
        session[:protected_page] = request.request_uri 
        flash[:notice] = "Please log in first" 
        redirect_to :controller => "user", :action => "login" 
        return false 
     end
  end


end

