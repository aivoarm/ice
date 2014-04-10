class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :inv_n
      t.string :supplier
      t.decimal :inv_amt, :precision => 16, :scale => 2

      t.timestamps
    end
  end
end
