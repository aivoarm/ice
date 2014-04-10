json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :inv_n, :supplier, :inv_amt
  json.url invoice_url(invoice, format: :json)
end
