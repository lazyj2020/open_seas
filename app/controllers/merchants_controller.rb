class MerchantsController < ApplicationController
  # GET /merchants
  # GET /merchants.xml
  def index
    @merchants = Merchant.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @merchants }
    end
  end

  # GET /merchants/1
  # GET /merchants/1.xml
  def show
    @merchant = Merchant.find(params[:id])
      session[:merchant_id] = params[:id]
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @merchant }
      end
  end

  # GET /merchants/new
  # GET /merchants/new.xml
  def new
    @merchant = Merchant.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @merchant }
    end
  end


  # GET /merchants/1/edit
  def edit
    @merchant = Merchant.find(params[:id])
  end

  # POST /merchants
  # POST /merchants.xml
  def create
    @merchant = Merchant.new(params[:merchant])

    respond_to do |format|
      if @merchant.save
        flash[:notice] = 'Merchant was successfully created.'
        format.html { redirect_to(@merchant) }
        format.xml  { render :xml => @merchant, :status => :created, :location => @merchant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @merchant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /merchants/1
  # PUT /merchants/1.xml
  def update
    @merchant = Merchant.find(params[:id])

    respond_to do |format|
      if @merchant.update_attributes(params[:merchant])
        flash[:notice] = 'Merchant was successfully updated.'
        format.html { redirect_to(@merchant) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @merchant.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /merchants/1
  # DELETE /merchants/1.xml
  def destroy
    @merchant = Merchant.find(params[:id])
    @merchant.destroy

    respond_to do |format|
      format.html { redirect_to(merchants_url) }
      format.xml  { head :ok }
    end
  end

=begin
  def sell
    @merchant_item = MerchantItem.find(params[:item])
    @ship_item = ShipItem.new
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @merchant_item }
    end
  end

  
  def complete_sale 
    @ship_item = ShipItem.new(params[:ship_item])
    @ship_item.ship_id = current_user.ship.id
    @ship_item.item_id = @merchant_item.item_id
    if (current_user.gold >= @merchant_item.value * @ship_item.quantity)
      @ship_item.save
      redirect_to(current_user.ship)
    end
  end
=end
  
end
