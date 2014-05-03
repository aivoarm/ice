class FileHeader < ActiveRecord::Base
    has_one :upload
    has_many :invoice_headers
    has_many :invoice_details
   validates_presence_of :FILE_DATE, :error => "Only letters F allowed"
#validates :RECORD_TYPE, presence: true, :format => { :with => /F/, :error => "Only letters F allowed" }
    
    #validates :FILE_DATE, length: { is: 11 , :error => "Only letters F allowed"}
end
