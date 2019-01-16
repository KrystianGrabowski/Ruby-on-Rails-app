class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :product_id
      t.float :former_price

      t.timestamps
    end
  end
end
