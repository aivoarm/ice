class CreateFileHeaders < ActiveRecord::Migration
  def change
    create_table :file_headers do |t|
      t.integer :line_num
      t.string :RECORD_TYPE
      t.integer :FILE_DATE
      t.string :SOURCE
      t.integer :INVOICE_COUNT
      t.decimal :INVOICE_AMOUNT
      t.string :TAX_VALIDATED
      t.boolean :valid

      t.timestamps
    end
  end
end
