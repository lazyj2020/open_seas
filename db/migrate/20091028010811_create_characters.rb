# Object to create the SQL table for Character model
class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.string :name
      t.integer :id
      t.timestamp :created
      t.integer :user_id
      t.integer :gold
      t.float :exp
      t.integer :lvl
      t.integer :exp_next
      #stats



      t.integer :total_points

#skill tree
     t.integer :lucky
     t.integer :penny
     t.integer :goldrush
     t.integer :cannonmastery
     t.integer :trueshot
     t.integer :shootingblind
     t.integer :olsturdy
     t.integer :smoothsailing
     t.integer :cargoreduction

      t.timestamps
    end
  end

  def self.down
    drop_table :characters
  end
end
