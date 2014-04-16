json.array!(@suppliers) do |supplier|
  json.extract! supplier, :id, :SupplierNo, :SupplerName, :Account, :SubAccount, :OU, :AB, :BC, :MA, :NB, :NF, :NS, :NU, :NT, :FC, :ONT, :PE, :QC, :SK, :YU, :IO, :IQ
  json.url supplier_url(supplier, format: :json)
end
