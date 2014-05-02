class InvoiceHeader < ActiveRecord::Base
     has_many :invoice_details
     belongs_to :file_header
end
