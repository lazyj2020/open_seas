# Object to create the SQL table for Battle model
class CreateBattles < ActiveRecord::Migration
  def self.up
    create_table :battles do |t|
      t.integer :id
      t.integer :ship1_id
      t.integer :ship2_id
      t.text :recap

      t.timestamps
    end
  end

  def self.down
    drop_table :battles
  end
end
