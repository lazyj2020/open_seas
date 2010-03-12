# Object to create the SQL table for Time Task model
class CreateTimeTasks < ActiveRecord::Migration
  def self.up
    create_table :time_tasks do |t|
      t.string :name
      t.string :task
      t.string :param1
      t.string :param2
      t.string :param3
      t.datetime :when

      t.timestamps
    end
  end

  def self.down
    drop_table :time_tasks
  end
end
