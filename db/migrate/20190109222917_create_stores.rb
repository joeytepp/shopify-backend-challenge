# frozen_string_literal: true

class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
      t.string :name
      t.belongs_to :owner, class_name: :User

      t.timestamps
    end
  end
end
