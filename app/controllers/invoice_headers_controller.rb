class InvoiceHeadersController < InheritedResources::Base
      protect_from_forgery with: :exception
    load_and_authorize_resource
    
    
end
