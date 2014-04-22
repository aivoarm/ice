class CreateSuppierFiles < ActiveRecord::Migration
  def change
    create_table :suppier_files do |t|
      t.string :filepath

      t.timestamps
    end
  end
end
