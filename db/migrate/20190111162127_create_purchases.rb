class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.string :quantity

      t.belongs_to :product
      t.belongs_to :user

      t.timestamps
    end
  end
end
