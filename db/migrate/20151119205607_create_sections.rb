class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.text :instructions

      t.timestamps null: false
    end
  end
end
