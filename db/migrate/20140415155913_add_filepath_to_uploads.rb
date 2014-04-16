class AddFilepathToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :filepath, :string
  end
end
