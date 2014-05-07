class AddSizeFtypeValidAddToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :size, :string
    add_column :uploads, :ftype, :string
    add_column :uploads, :valid, :boolean
  end
end
