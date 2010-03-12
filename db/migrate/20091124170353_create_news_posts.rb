class CreateNewsPosts < ActiveRecord::Migration
  def self.up
    create_table :news_posts do |t|
      t.string :author
      t.string :subject
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :news_posts
  end
end
