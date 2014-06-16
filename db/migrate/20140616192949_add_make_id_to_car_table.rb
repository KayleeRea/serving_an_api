class AddMakeIdToCarTable < ActiveRecord::Migration
  def change
    add_column :cars, :make_id, :integer
  end
end
