class RemoveStringFromSuppliers < ActiveRecord::Migration
  def change
    remove_column :suppliers, :string, :string
  end
end
