class FileHeader < ActiveRecord::Base
    has_one :upload
    has_many :invoice_headers
    has_many :invoice_details
    
end
