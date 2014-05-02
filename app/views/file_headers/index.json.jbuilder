json.array!(@file_headers) do |file_header|
  json.extract! file_header, :id, :line_num, :RECORD_TYPE, :FILE_DATE, :SOURCE, :INVOICE_COUNT, :INVOICE_AMOUNT, :TAX_VALIDATED, :valid
  json.url file_header_url(file_header, format: :json)
end
