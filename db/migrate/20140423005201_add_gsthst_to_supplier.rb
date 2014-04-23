class AddGsthstToSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :GSTHST, :string
  end
end
