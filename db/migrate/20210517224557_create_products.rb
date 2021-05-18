class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    drop_table :products
    create_table :products do |t|
      t.string :title
      t.string :description
      t.string :image
      t.string :url
      t.string :provider

      t.timestamps
    end
  end
end
