class InvoiceH < ActiveRecord::Base
   has_one :invoice,  :class_name => "Invoice", :foreign_key => "id"
end
