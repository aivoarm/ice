json.array!(@invoice_details) do |invoice_detail|
  json.extract! invoice_detail, :id, :line_num, :RECORD_TYPE, :FILE_DATE, :VENDOR_NUMBER, :PROVINCE_TAX_CODE, :INVOICE_NUMBER, :ITEM_AMOUNT, :GST_AMOUNT, :PST_AMOUNT, :COST_CENTER_SEGMENT, :ACCOUNT_SEGMENT, :SUB_ACCOUNT_SEGMENT, :SOURCE, :FILLER, :valid
  json.url invoice_detail_url(invoice_detail, format: :json)
end
