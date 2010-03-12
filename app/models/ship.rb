# Model for Ship class.  Contains all methods pertaining to Ship.
class Ship < ActiveRecord::Base
  belongs_to :character
  belongs_to :port
  has_one :ship_attribute
  has_many :crews
  has_many :ship_items
  has_many :tactics

  # Returns the speed of the ship.  Calculated as the log of all speed-increasing items
  # equipped to the ship and modified if the character has Smooth Sailing skill.
  def speed
    spd = 0
    ship_items.each do | itm |
      if itm.equiped
      spd += itm.item.speed_w
    end
    end
    if spd <= 0
      spd = 1
    end
    x = Math.log10(spd)
    x *= x
    @mods = get_crew_mods
    x *= @mods[:speed]
    if (self.character.smoothsailing > 0)
      x *= 1.5
    end
    return x
  end
  
  # Returns the average attack of the cannons equipped to the ship.
  def attack
    atk = 0
    count = 0
    ship_items.each do | itm |
      if itm.equiped
      if (itm.item.attack_w > 0)
        atk += itm.item.attack_w
        count+=1
      end
    end
    end
    mods = get_crew_mods
    atk += mods[:attack]*count
    if count == 0
      count = 1
    end
    return atk/count
  end
  
  # Returns the average accuracy of the cannons equipped to the ship.
  def accuracy
    acc = 0
    count = 0
    ship_items.each do | itm |
      if itm.equiped
      if (itm.item.accuracy_w > 0)
        acc += itm.item.accuracy_w
        count+=1
      end
      end
    end
    if count == 0
      count = 1
    end
    return acc/count
  end
  
  # Returns the evasion of the ship as the sum of all the evasion-modifying 
  # equipped items divided by 100.
  def evasion
    eva = 0
    ship_items.each do | itm |
      if itm.equiped
      eva += itm.item.evasion_w
      end
    end
    mods = get_crew_mods
    eva *= mods[:evasion]
    return eva / 100
  end
  
  # Returns the hitpoints of the ship.
  def hitpoints
    hp = ship_attribute.structure
    ship_items.each do | itm |
      if itm.equiped
      hp += itm.item.hitpoints_w
    end
    end
    return hp + (self.character.olsturdy * 20)
  end
  
  # Returns the total volume of the ship's cargo.
  def cargo
    return ship_attribute.cargo + (self.character.cargoreduction * 20)
  end
  
  # Returns the number of available equip slots for the slot type specified 
  def get_empty_slots(slot_type)
    count = 0
    ship_items.each do | itm |
      if itm.equiped and itm.item.slot == slot_type
        count += 1
      end
    end
    return ship_attribute.get_max_slots(slot_type) - count
  end
  
  # Returns the number of used equip slots for the slot type specified
  def get_used_slots(slot_type)
    count = 0
    ship_items.each do | itm |
      if itm.equiped and itm.item.slot == slot_type
        count += 1
      end
    end
    return count
  end
  
  # Creates a standard collection of items given to new players.
  # * 2 Cannons
  # * 1 Basic Rudder
  # * 1 Basic Jib Sail
  # * 1 Basic Main Sail
  # * 2 Rum Trade Items
  def create_std_items
    ShipItem.new(
      :item_id => 25,
      :ship_id => self.id,
      :quantity => 2,
      :equiped => false
      ).save
    ShipItem.new(
      :item_id => 15,
      :ship_id => self.id,
      :quantity => 1,
      :equiped => false
      ).save
    ShipItem.new(
      :item_id => 12,
      :ship_id => self.id,
      :quantity => 1,
      :equiped => false
      ).save
    ShipItem.new(
      :item_id => 9,
      :ship_id => self.id,
      :quantity => 1,
      :equiped => false
      ).save
    ShipItem.new(
      :item_id => 2,
      :ship_id => self.id,
      :quantity => 2,
      :equiped => false
      ).save
  end
  
  # Returns a hash of total stat modifications of equipped crew members
  def get_crew_mods
    mods = {}
    mods[:attack] = 0
    mods[:evasion] = 1
    mods[:accuracy] = 0
    mods[:speed] = 1
    mods[:hitpoints] = 1
    ship_items.each do | itm |
      if itm.item.slot == 'crew'
        mods[:attack] += itm.item.attack_w
        mods[:evasion] += itm.item.evasion_w
        mods[:accuracy] += itm.item.accuracy_w
        mods[:speed] += itm.item.speed_w
        mods[:hitpoints] += itm.item.hitpoints_w
      end
    end
    return mods
  end
end

