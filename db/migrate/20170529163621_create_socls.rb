class CreateSocls < ActiveRecord::Migration[5.1]
  def change
    create_table :socls do |t|
      t.string :name
      t.string :title
      t.datetime :uploadTime
      t.string :plays
      t.string :link
      t.datetime :postedTime

      t.timestamps
    end
  end
end
