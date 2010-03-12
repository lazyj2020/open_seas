# Object to create the SQL table for Option model
class Options < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.integer :id
      t.string :typ
      t.string :opt

      t.timestamps
    end
  end

  def self.down
    drop_table :options
  end
end
