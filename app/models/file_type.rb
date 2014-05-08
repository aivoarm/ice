class FileType < ActiveRecord::Base
    belongs_to :country, foreign_key: "countr_id"
end
