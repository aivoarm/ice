class CreateInvoiceHeaders < ActiveRecord::Migration
  def change
    create_table :invoice_headers do |t|
      t.integer :line_num
      t.string :RECORD_TYPE
      t.integer :FILE_DATE
      t.string :VENDOR_NUMBER
      t.string :PROVINCE_TAX_CODE
      t.string :CURRENCY_CODE
      t.string :INVOICE_NUMBER
      t.integer :INVOICE_DATE
      t.decimal :INVOICE_AMOUNT
      t.decimal :ITEM_AMOUNT
      t.decimal :GST_AMOUNT
      t.decimal :PST_AMOUNT
      t.string :COMPANY_CODE_SEGMENT
      t.string :TAX_VALIDATED
      t.string :VENDOR_SITE_CODE
      t.string :SOURCE
      t.boolean :valid

      t.timestamps
    end
  end
end
