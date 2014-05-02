class CreateInvoiceDetails < ActiveRecord::Migration
  def change
    create_table :invoice_details do |t|
      t.integer :line_num
      t.string :RECORD_TYPE
      t.integer :FILE_DATE
      t.string :VENDOR_NUMBER
      t.string :PROVINCE_TAX_CODE
      t.string :INVOICE_NUMBER
      t.decimal :ITEM_AMOUNT
      t.decimal :GST_AMOUNT
      t.decimal :PST_AMOUNT
      t.string :COST_CENTER_SEGMENT
      t.string :ACCOUNT_SEGMENT
      t.string :SUB_ACCOUNT_SEGMENT
      t.string :SOURCE
      t.string :FILLER
      t.boolean :valid

      t.timestamps
    end
  end
end
