# Object to create the SQL table for Ship Attribute model
class CreateShipAttributes < ActiveRecord::Migration
  def self.up
    create_table :ship_attributes do |t|
      t.integer :ship_id
      t.integer :id
      t.integer :cargo
      t.integer :weapon_slot
      t.integer :mast_slot
      t.integer :crew_slot
      t.integer :custom_slot
      t.integer :structure
      t.integer :rudder_slot

      t.timestamps
    end
  end

  def self.down
    drop_table :ship_attributes
  end
end
