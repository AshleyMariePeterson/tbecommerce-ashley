object @color_type
attributes :id, :name, :presentation, :position, :selector
child :color_values => :color_values do
  attributes :id, :name, :presentation, :color_type_name, :color_type_id, :color_type_presentation, :description, :thumb_url, :small_url, :medium_url, :large_url, :price, :position
end