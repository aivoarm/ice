class CreateInvoiceHs < ActiveRecord::Migration
  def change
    create_table :invoice_hs do |t|
      t.integer :inv_id
      t.string :province
      t.boolean :valid

      t.timestamps
    end
  end
end
