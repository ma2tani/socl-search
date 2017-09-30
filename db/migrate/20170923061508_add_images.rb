class AddImages < ActiveRecord::Migration[5.1]
  def change
      add_column :socls, :image, :string
  end
end
