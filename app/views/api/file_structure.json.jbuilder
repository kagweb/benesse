json.key_format! :camelize => :lower

json.array! directory_to_array(0) do |file|
  json.file file
end
