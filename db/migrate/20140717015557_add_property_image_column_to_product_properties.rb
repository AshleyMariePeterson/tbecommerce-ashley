class AddPropertyImageColumnToProductProperties < ActiveRecord::Migration
  def self.up
    add_attachment :spree_product_properties, :property_image
  end

  def self.down
    add_attachment :spree_product_properties, :property_image
  end
end
