class AddUserToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :user, :string
  end
end
