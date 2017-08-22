class AddTopMatchToGroups < ActiveRecord::Migration[5.0]
  def change
    add_column :groups, :top_match, :string
  end
end
