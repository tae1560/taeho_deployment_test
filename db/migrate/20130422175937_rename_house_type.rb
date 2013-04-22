class RenameHouseType < ActiveRecord::Migration
  def up
    rename_column :houses, :type, :house_type
  end

  def down
    rename_column :houses, :house_type, :type
  end
end
