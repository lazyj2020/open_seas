# Object to create the SQL table for Ship model
class CreateShips < ActiveRecord::Migration
  def self.up
    create_table :ships do |t|
      t.string :name
      t.integer :id
      t.integer :character_id
      t.integer :port_id
      t.integer :curr_hp
      t.integer :aggressive
      t.string  :attack_mod_type
      t.integer :attack_mod_num
      t.integer :flee
      t.string :flee_mod_type
      t.integer :flee_mod_num

      t.timestamps
    end
  end

  def self.down
    drop_table :ships
  end
end
