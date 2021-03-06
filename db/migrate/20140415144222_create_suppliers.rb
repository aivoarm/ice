class CreateSuppliers < ActiveRecord::Migration
 def change
    create_table :suppliers do |t|
      t.string :OU
      t.string :SupplierNo
      t.string :SupplerName
      t.string :AB
      t.string :BC
      t.string :MA
      t.string :NB
      t.string :NF
      t.string :NS
      t.string :NU
      t.string :NT
      t.string :FC
      t.string :ONT
      t.string :PE
      t.string :QC
      t.string :SK
      t.string :YU
      t.string :IO
      t.string :IQ
      t.string :GSTHST
      t.string :Account
      t.string :SubAccount
      
      t.timestamps
    end
  end
end
