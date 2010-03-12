# Object to create the SQL table for Route model
class CreateRoutes < ActiveRecord::Migration
  def self.up
    create_table :routes do |t|
      t.integer :id
      t.integer :start_id
      t.integer :end_id
      t.integer :distance
      t.integer :common_id

      t.timestamps
    end
  end

  def self.down
    drop_table :routes
  end
end
