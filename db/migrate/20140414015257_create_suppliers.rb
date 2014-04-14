class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :supplierNumber
      t.string :supplierName
      t.string :GL
      t.string :ON
      t.string :QC
      t.string :BC
      t.string :AB
      t.string :NL
      t.string :MA
      t.string :SK
      t.string :NF
      t.string :PEI
      t.string :NT

      t.timestamps
    end
  end
end
