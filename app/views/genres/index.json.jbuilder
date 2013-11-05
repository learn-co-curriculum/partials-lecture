json.array!(@genres) do |genre|
  json.extract! genre, :name
  json.url genre_url(genre, format: :json)
end
