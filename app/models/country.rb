class Country < ActiveRecord::Base
    has_many :file_types
end
