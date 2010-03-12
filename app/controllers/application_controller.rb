# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

   #session  :session_key    =>  '_open_seas_session_id' 
include  ApplicationHelper 

  before_filter     :protect,   :except   => [:index,:about,:help,:register,:login,:new] 
   before_filter    :check_authorization 
   before_filter    :process_time_task
#private

  # Protect a page from unauthorized access.
  def protect
     unless logged_in? or session[:registering]
        session[:protected_page] = request.request_uri 
        flash[:notice] = "Please log in first" 
        redirect_to :action => "login" , :controller => "user" 
        return false 
     end
  end
  

   def check_authorization 
     authorization_token     =  cookies[:authorization_token] 
     if  authorization_token     and  not  logged_in? 
       user   = User.find_by_authorization_token(authorization_token) 
       user.login!(session)      if  user 
     end 
   end 
   
   #Time Task for various functions
  def process_time_task
    @times = TimeTask.find(:all)
    found = false
    #Rails.logger.info(@times != nil)
    if @times != nil
      found = false
      @times.each do |@task|
        if @task.task == "timed_event"
          found = true
        end
        if @task.when <= Time.now
          case @task.task
            when "move_ship"
              @ship = Ship.find(@task.param1)
              @ship.update_attribute(:port_id, @task.param2)
              @ship.update_attribute(:aggressive,"0")
              @ship.update_attribute(:curr_hp,"#{@ship.hitpoints}")
              #Rails.logger.info("did #{@task.name}")
              @task.destroy
            when "timed_event"
              move_merchant
              #do shit
                
              @task.destroy
              scheduled_timed_task
            when "battle"
              #battle shit
                
              @battle = Battle.new().battle(@task.param1, @task.param2)
               flash[:notice] = "You were in a battle!!<a href= http://127.0.0.1:3000/battles/#{@battle.id}><font color="#009900"> click</font></a>"
              @task.destroy

              #Rails.logger.info("did #{@task.name}")
            when "show_battle"
              if logged_in? && current_ship
                if (current_ship.id == @task.param1.to_i)
                  flash[:notice] = "You were in a battle!! 
  <a href=\"#\" onClick=\"show_battle_mini('#{@task.param2}'); return false\"><span style=\"color: #FF0000;\">Click Here</span></a>"
                  
              end
            end
          
          end
        end
      end
    end
   if !found
      scheduled_timed_task
   
   end
  end
  
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
