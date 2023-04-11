# frozen_string_literal: true

class CreateTodos < ActiveRecord::Migration[7.0]
  def change
    create_table :todos do |t|
      t.string :title
      t.text :description
      t.date :due_date
      t.boolean :completed, default: false
      t.integer :position 
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
