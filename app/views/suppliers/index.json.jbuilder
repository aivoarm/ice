json.array!(@suppliers) do |supplier|
  json.extract! supplier, :id, :supplierNumber, :supplierName, :GL, :ON, :QC, :BC, :AB, :NL, :MA, :SK, :NF, :PEI, :NT
  json.url supplier_url(supplier, format: :json)
end
