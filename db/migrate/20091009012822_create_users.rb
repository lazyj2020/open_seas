# Object to create the SQL table for User model
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :account
      t.string :email
      t.string :password
      t.boolean :admin
      t.integer :id
    end
  end

  def self.down
    drop_table :users
  end
end
