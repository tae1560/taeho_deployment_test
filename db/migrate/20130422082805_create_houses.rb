class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.string  :trade_type
      t.string  :type
      t.datetime  :confirm_date
      t.string  :name
      t.string  :price

      t.integer :town_id, :index => true

      t.timestamps
    end
  end
end
