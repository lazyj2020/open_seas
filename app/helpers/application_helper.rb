# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Return   a link  for  use  in  layout  navigation. 
  def nav_link(text, controller, action="index") 
    link_to_unless_current text, :controller => controller, :action =>  action 
  end 
   
  # Return   true  if  some  user  is  logged   in,  false  otherwise. 
  def logged_in? 
    not session[:user_id].nil? 
  end
   
  def admin?
    if logged_in?
      return User.find(session[:user_id]).admin
    end
    return false
  end
  
  def currently_moving
    @task = TimeTask.find(:first, :conditions => { :task => "move_ship", :param1 => session[:user_id] })
    if @task != nil and @task.when > Time.now
      return true
    else
      return false
    end
    
  end
  
  
  def currently_moving_to
    @task = TimeTask.find(:first, :conditions => { :task => "move_ship", :param1 => session[:user_id] })
    if @task != nil and @task.when > Time.now
      return Port.find_by_id(@task.param2)
    else
      return false
    end
    
  end
  
  def convert_seconds_to_time(seconds)
    total_minutes = seconds / 1.minutes
    seconds_in_last_minute = seconds - total_minutes.minutes.seconds
    return "#{total_minutes} minutes #{seconds_in_last_minute} seconds"
  end
  

  def moving_time_left
    if currently_moving
      @task = TimeTask.find(:first, :conditions => { :task => "move_ship", :param1 => session[:user_id] })
      if @task.when-Time.now > 60
        return convert_seconds_to_time(number_with_precision(@task.when-Time.now, :precision => 0).to_i)
      else
        return  number_with_precision(@task.when-Time.now, :precision => 0) + " seconds"
      end
    else
      return "Arrived!"
    end
  end
  
  def moving_progress
    if currently_moving
      @task = TimeTask.find(:first, :conditions => { :task => "move_ship", :param1 => session[:user_id] })

        return number_with_precision(((@task.when-@task.created_at)-(@task.when-Time.now))/(@task.when-@task.created_at)*100, :precision => 0).to_i
    else
        return 100
    end
  end
  
  def current_user
    User.find(session[:user_id])
  end
   
  def current_character
    Character.find(:first, :conditions => { :user_id => session[:user_id] })
  end
  
  def current_ship
    if current_character != nil
    Ship.find(:first, :conditions => { :character_id => current_character.id })
    end
  end
  
  def current_cargo
    @temp = 0
    if current_character != nil
      current_ship.ship_items.each do |ship_item|
        if !ship_item.equiped
          @temp = @temp + ship_item.total_volume
        end
      end
    end
    return @temp
  end
  
  def current_ship_attributes
    if current_character != nil
    current_ship.ship_attribute
    end
  end
  
  def current_ship_items
    if current_character != nil
      current_ship.ship_items
    end
  end
  
  def current_ship_items_item(id)
    if current_character != nil
      ShipItem.find(:first, :conditions => { :ship_id => current_ship.id, :item_id =>id } )
    end
  end
  
  def current_ship_items_item_unequipped(id)
    if current_character != nil
      ShipItem.find(:first, :conditions => { :ship_id => current_ship.id, :item_id =>id, :equiped => false } )
    end
  end
  
  def current_ship_items_item_equipped(id)
    if current_character != nil
      ShipItem.find(:first, :conditions => { :ship_id => current_ship.id, :item_id =>id, :equiped => true } )
    end
  end
  
  def not_trade?(item_id)
    Item.find(item_id).slot != "trade"
  end
  
  def checklist(name, collection, value_method, display_method, selected)
    selected ||= []
    
    ERB.new(%{
    <div class="checklist" style="border:1px solid #666; width:20em; height:5em; overflow:auto">
      <% for item in collection %>
        <%= check_box_tag name, item.send(value_method), selected.include?(item.send(value_method)) %> <%=h item.send(display_method) %><br />
      <% end %>
    </div>}).result(binding)
  end
  
  def link_to_back (description = "Back")
   referer = request.env["HTTP_REFERER"]
   return false if !referer
   getIt = request.env["REQUEST_URI"].split("?")[1]
   if getIt.nil?
     getIt = ""
     else
       getIt = "?" + getIt if !getIt.match(/\?/)
   end
   link_to description, referer + getIt
end
  
  def count_unread
    @temp = current_user.received_messages.find(:all, :conditions => [" `read` = ?", false])
    return @temp.size
  end
  
  def count_all_mail
    @temp = current_user.received_messages.find(:all)
    return @temp.size
  end
  
  
end

#randomly moves one merchant from a port to a random port
def move_merchant
 @merchcount= Merchant.count(:all)-1
 @portcount=Port.count(:all)
  @merchid=rand(@merchcount)+1
 @merchant = Merchant.find(@merchid)
 @portid=rand(@portcount)+1
@merchant.port_id=@portid
@numitems=rand(3)
#@i=0
#while(@i<=@numitems)
#@merchantitem=MerchantItem.new

#@merchantitem.id=MerchantItem.count+1
#@itemrand=rand(Item.count-1)+1
 # @merchantitem.item_id=@itemrand
  #@i=@i+1
  #@merchantitem.update_attributes(params[:merchant_items])
#end
 #@merchantitem.merchant_id= @merchid
@merchant.update_attributes(params[:merchant])
end


  def scheduled_timed_task
 #   @task = TimeTask.find(:first, :conditions => { :task => "set_time", :param1 => "system", :param2 => "30m" })
 #     if @task == nil   
        @time_task = TimeTask.new(
        :name => "30 min event",
        :task => "timed_event",
        :param1 => "system",
        :param2 => "10",
        :when => 30.minutes.from_now
        )
        @time_task.save
  #    end
  end
