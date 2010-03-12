class ShipItemsController < ApplicationController
  
  include ApplicationHelper
  
  def new
    @ship_item = ShipItem.new
    session[:value] = params[:value].to_i
    session[:item] = params[:item].to_i
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ship_item }
    end
  end
  
  def sell
    @ship_item = ShipItem.new
    session[:value] = params[:value].to_i
    session[:item] = params[:item].to_i
    respond_to do |format|
      format.html # sell.html.erb
      format.xml  { render :xml => @ship_item }
    end
  end
  
  # GET /ports/1
  # GET /ports/1.xml
  def show
    @ship_item = ShipItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ship_item }
    end
  end
  
  #unequip item a ship has in its cargo
  def unequip
    @ship_item = ShipItem.find(params[:id])
  if ( current_ship_items_item_unequipped(@ship_item.item_id) != nil )
      current_ship_items_item_unequipped(@ship_item.item_id).update_attribute(:quantity, current_ship_items_item_unequipped(@ship_item.item_id).quantity+1)
    @ship_item.destroy
    
    respond_to do |format|
      flash[:notice] = 'Unequipped '+ Item.find(@ship_item.item_id).name
      format.html { redirect_to(current_ship) }
      format.xml  { render :xml => @ship_item }
    end
  else
    @ship_item.update_attribute(:equiped, false)
    
    respond_to do |format|
      flash[:notice] = 'Unequipped '+ Item.find(@ship_item.item_id).name
      format.html { redirect_to(current_ship) }
      format.xml  { render :xml => @ship_item }
    end
    end
  end
  
  #equip item that a ship has in its cargo
  def equip
    @ship_item = ShipItem.find(params[:id])
    if (current_ship.get_empty_slots(@ship_item.item.slot) > 0)
      if (@ship_item.quantity > 1)
        @ship_item_temp = ShipItem.new(:item_id =>@ship_item.item_id, :ship_id => @ship_item.ship_id, :quantity => 1, :equiped => true)
        @ship_item_temp.save
        @ship_item.update_attribute(:quantity, @ship_item.quantity-1)
      else
        @ship_item.update_attribute(:equiped, true)
    end
     respond_to do |format|
        flash[:notice] = 'Equipped '+ Item.find(@ship_item.item_id).name
        format.html { redirect_to(current_ship) }
        format.xml  { render :xml => @ship_item}
      end
    else
      respond_to do |format|
        flash[:notice] = "You do not enough #{@ship_item.item.slot} slots"
        format.html { redirect_to(current_ship) }
        format.xml  { render :xml => @ship_item}
      end
    end
  end
  
  #delete a ship item but is also where sell is located
   def delete
    @ship_item = ShipItem.new(params[:ship_item])
    @ship_item.item_id = session[:item]
    @ship_item.ship_id = current_character.ship.id
    
    if ((@ship_item.quantity != nil ) && (current_ship_items_item(@ship_item.item_id).equiped == false))
      if (current_ship_items_item(@ship_item.item_id) != nil)
        if (@ship_item.quantity <= current_ship_items_item(@ship_item.item_id).quantity )   
          current_character.update_attribute(:gold,current_character.gold + Integer(session[:value])* @ship_item.quantity)    
          current_ship_items_item(@ship_item.item_id).update_attribute(:quantity, current_ship_items_item(@ship_item.item_id).quantity - @ship_item.quantity)
          current_character.update_attribute(:exp,"#{current_character.exp+0.01*@ship_item.quantity}")
          if (current_ship_items_item(@ship_item.item_id).quantity == 0)
            ShipItem.destroy(current_ship_items_item(@ship_item.item_id).id)
          end
          respond_to do |format|        
            flash[:notice] = "Sold #{@ship_item.quantity.to_s} #{Item.find(@ship_item.item_id).name}"
            session.delete(:value)
            session.delete(:item)
            format.html { redirect_to(Merchant.find(session[:merchant_id])) }
            format.xml  { render :xml => @item, :status => :created, :location => @item }
          end
        else
          flash[:notice] = 'You don\'t have enough to sell.'
          session.delete(:value)
          session.delete(:item)
          redirect_to(Merchant.find(session[:merchant_id]))
        end
      else
        flash[:notice] = "You don\'t have any #{Item.find(@ship_item.item_id).name}"
        session.delete(:value)
        session.delete(:item)
        redirect_to(Merchant.find(session[:merchant_id]))
      end
        
    else   
      flash[:notice] = 'Must enter amount to sell.'
      session.delete(:value)
      session.delete(:item)
      redirect_to(Merchant.find(session[:merchant_id]))
    end
  end
  
  #Create a ship item, also where buy is implemented
  def create
    @ship_item = ShipItem.new(params[:ship_item])
    @ship_item.item_id = session[:item]
    @ship_item.equiped = 0
    @ship_item.ship_id = current_ship.id
        
  if (@ship_item.quantity != nil )
    if(@ship_item.quantity <= (current_ship.cargo - current_cargo)/@ship_item.item.volume)
    if (Integer(session[:value]) * Integer(@ship_item.quantity) > current_character.gold)
      flash[:notice] = 'Not enough gold.'
      redirect_to(Merchant.find(session[:merchant_id]))
    else
      current_character.update_attribute(:gold,current_character.gold - Integer(session[:value]* @ship_item.quantity))
      #current_character.save
      
       respond_to do |format|
      if (current_ship_items_item(@ship_item.item_id) == nil) || ((current_ship_items_item(@ship_item.item_id).equiped == true))
        if (current_ship_items_item_unequipped(@ship_item.item_id) != nil)
          current_ship_items_item_unequipped(@ship_item.item_id).update_attribute(:quantity, current_ship_items_item(@ship_item.item_id).quantity+1)
        else
            @ship_item.save
        end
      else
        current_ship_items_item(@ship_item.item_id).update_attribute(:quantity, current_ship_items_item(@ship_item.item_id).quantity + @ship_item.quantity)
      end
            flash[:notice] = "Purchased #{@ship_item.quantity.to_s} #{Item.find(@ship_item.item_id).name}"
            session.delete(:value)
            session.delete(:item)
           format.html { redirect_to(Merchant.find(session[:merchant_id])) }
           format.xml  { render :xml => @item, :status => :created, :location => @item }

        end

   
    end
   else   
    
      flash[:notice] = 'Ship can not hold that much.'
          session.delete(:value)
          session.delete(:item)
      redirect_to(Merchant.find(session[:merchant_id]))
    end
   else   
    
      flash[:notice] = 'Must enter amount to buy.'
          session.delete(:value)
          session.delete(:item)
      redirect_to(Merchant.find(session[:merchant_id]))
    end
  end
  
  
end
