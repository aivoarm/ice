class Invoice
 include ActiveModel::Serialization
 attr_accessor :number, :amount, :supplier, :ou, :account
 
 def initialize(attributes = {})
  @name=attributes[:number]
  @company_name=attributes[:amount]
  @email=attributes[:supplier]
  @phone=attributes[:ou]
  @comment=attributes[:account]
 end
  
# persisted is important not to get "undefined method `to_key' for" error
 def persisted?
  false
 end
  
end