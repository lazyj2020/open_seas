# Object to create the SQL table for Merchant Item model
class CreateMerchantItems < ActiveRecord::Migration
  def self.up
    create_table :merchant_items do |t|
      t.integer :id
      t.float :buy_w
      t.float :sell_w
      t.integer :merchant_id
      t.integer :item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :merchant_items
  end
end
