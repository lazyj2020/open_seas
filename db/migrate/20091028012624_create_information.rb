class CreateInformation < ActiveRecord::Migration
  def self.up
    create_table :information do |t|
      t.integer :id
      t.timestamp :created

      t.timestamps
    end
  end

  def self.down
    drop_table :information
  end
end
