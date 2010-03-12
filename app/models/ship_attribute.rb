# Stores all the attributes for the Ship object.
class ShipAttribute < ActiveRecord::Base
  belongs_to :ship
  
  # Returns the maximum amount of slots for the given slot string.
  def get_max_slots(slot_type)
    case slot_type
      when "weapon"
        return weapon_slot
      when "mast"
        return mast_slot
      when "crew"
        return crew_slot
      when "custom"
        return custom_slot
      when "rudder"
        return rudder_slot
      else
        return nil
    end
  end
end
