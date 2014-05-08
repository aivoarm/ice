json.array!(@filetypes) do |filetype|
  json.extract! filetype, :id, :ftype, :country
  json.url filetype_url(filetype, format: :json)
end
