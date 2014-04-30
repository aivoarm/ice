class CreateLayoutFiles < ActiveRecord::Migration
  def change
    create_table :layout_files do |t|
      t.string :filepath

      t.timestamps
    end
  end
end
