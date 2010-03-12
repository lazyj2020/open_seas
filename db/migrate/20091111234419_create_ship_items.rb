# Object to create the SQL table for Ship Item model
class CreateShipItems < ActiveRecord::Migration
  def self.up
    create_table :ship_items do |t|
      t.integer :id
      t.integer :item_id
      t.integer :ship_id
      t.integer :quantity
      t.boolean :equiped

      t.timestamps
    end
  end

  def self.down
    drop_table :ship_items
  end
end
