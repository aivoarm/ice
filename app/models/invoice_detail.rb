class InvoiceDetail < ActiveRecord::Base
   
    belongs_to :invoice_header
end
