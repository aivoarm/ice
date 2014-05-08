class CreateFileTypes < ActiveRecord::Migration
  def change
    create_table :file_types do |t|
      t.string :ftype
      t.integer :countr_id

      t.timestamps
    end
  end
end
