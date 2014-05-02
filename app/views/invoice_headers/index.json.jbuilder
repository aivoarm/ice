json.array!(@invoice_headers) do |invoice_header|
  json.extract! invoice_header, :id, :line_num, :RECORD_TYPE, :FILE_DATE, :VENDOR_NUMBER, :PROVINCE_TAX_CODE, :CURRENCY_CODE, :INVOICE_NUMBER, :INVOICE_DATE, :INVOICE_AMOUNT, :ITEM_AMOUNT, :GST_AMOUNT, :PST_AMOUNT, :COMPANY_CODE_SEGMENT, :TAX_VALIDATED, :VENDOR_SITE_CODE, :SOURCE, :valid
  json.url invoice_header_url(invoice_header, format: :json)
end
