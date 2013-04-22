class AddIndexToCityAndTown < ActiveRecord::Migration
  def change
    add_index :cities, :cortarNo
    add_index :towns, :cortarNo
    add_index :towns, :city_id
  end
end
