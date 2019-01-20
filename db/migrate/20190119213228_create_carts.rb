# frozen_string_literal: true

class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.belongs_to :user
      t.boolean :checked_out
      t.timestamps
    end
  end
end
