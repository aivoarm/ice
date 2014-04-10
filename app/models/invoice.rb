class Invoice < ActiveRecord::Base
  has_one :invoice_h,  :class_name => "InvoiceH", :foreign_key => "inv_id"
end
