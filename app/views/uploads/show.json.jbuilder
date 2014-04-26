
json.array!(@file) do |file|
  json.extract! file, :id, :filepath
 
end
