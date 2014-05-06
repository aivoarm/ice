json.array!(@fheader) do |user|
  json.extract! 
  json.url user_url(user, format: :json)
end
