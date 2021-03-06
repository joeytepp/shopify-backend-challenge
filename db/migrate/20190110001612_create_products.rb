# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :title
      t.float :price
      t.integer :inventory_count

      t.belongs_to :store

      t.timestamps
    end
  end
end
