json.array!(@layouts) do |layout|
  json.extract! layout, :id, :description, :start, :length, :ftype, :ou
  json.url layout_url(layout, format: :json)
end
