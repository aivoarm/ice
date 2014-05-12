class Validfile < ActiveRecord::Base
    
    validates :filepath, uniqueness: true
    
end
