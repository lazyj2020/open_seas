# Class for persistence of an Item object stored on a ship. 
class ShipItem < ActiveRecord::Base
  belongs_to :ship
  belongs_to :item
  
  # Returns the total volume of the Items, taking into account quantity.
  def total_volume
    quantity * Item.find(item_id).volume
  end
  
  # Returns the name string if the Item
  def name
    Item.find(item_id).name
  end
  
  # Returns the slot string for the Item
  def slot
    Item.find(item_id).slot
  end
  
end
