class InvoiceDetail < ActiveRecord::Base
   
    belongs_to :invoice_header, :foreign_key => 'INVOICE_NUMBER'
end
