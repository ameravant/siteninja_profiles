class AddShortDescriptionToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :short_description, :text
  end

  def self.down
    remove_column :profiles, :short_description
  end
end
