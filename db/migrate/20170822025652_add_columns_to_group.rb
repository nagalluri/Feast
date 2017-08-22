class AddColumnsToGroup < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :food_filter5, :boolean
    add_column :groups, :food_filter6, :boolean
    add_column :groups, :food_filter7, :boolean
    add_column :groups, :food_filter8, :boolean
    add_column :groups, :food_filter9, :boolean
    add_column :groups, :food_filter10, :boolean
    add_column :groups, :food_filter11, :boolean
    add_column :groups, :food_filter12, :boolean
  end
end
