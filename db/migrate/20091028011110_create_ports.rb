# Object to create the SQL table for Port model
class CreatePorts < ActiveRecord::Migration
  def self.up
    create_table :ports do |t|
      t.string :name
      t.integer :id

      t.timestamps
    end
  end

  def self.down
    drop_table :ports
  end
end
