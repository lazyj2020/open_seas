# Object to create the SQL table for Merchant model
class CreateMerchants < ActiveRecord::Migration
  def self.up
    create_table :merchants do |t|
      t.integer :id
      t.string :name
      t.integer :port_id
      t.integer :rarity

      t.timestamps
    end
  end

  def self.down
    drop_table :merchants
  end
end
