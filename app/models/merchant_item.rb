# Class for storing information about Items pertaining to a specific merchant. 
class MerchantItem < ActiveRecord::Base
  belongs_to :merchant
  
  # Returns the Item's name
  def name
    Item.find(item_id).name
  end
  
  # Returns the Item's buy value, taking into account the character's Penny Pincher Skill 
  def buy_value(penny)
   (Item.find(item_id).price_w * buy_w)*(1.00-(penny*0.015))
  end
  
  # Returns the Item's buy value, taking into account the character's Penny Pincher Skill
  def sell_value(penny)
   (Item.find(item_id).price_w * sell_w)*(1.00+(penny*0.015))
  end
end


