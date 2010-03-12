# Object to create the SQL table for Item model
class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :id
      t.string :name
      t.integer :volume
      t.float :hitpoints_w
      t.float :speed_w
      t.float :attack_w
      t.float :accuracy_w
      t.float :evasion_w
      t.integer :price_w
      t.string :slot
      

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
