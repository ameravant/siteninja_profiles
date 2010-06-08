class AddPrivacyOptionsToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :show_email, :boolean, :default => true
    add_column :profiles, :show_phone, :boolean, :default => false
    add_column :profiles, :show_company, :boolean, :default => true
    add_column :profiles, :show_title, :boolean, :default => true
    add_column :profiles, :show_web_address, :boolean, :default => true
    add_column :profiles, :show_address1, :boolean, :default => false
    add_column :profiles, :show_address2, :boolean, :default => false
    add_column :profiles, :show_state, :boolean, :default => true
    add_column :profiles, :show_city, :boolean, :default => true
    add_column :profiles, :show_zip, :boolean, :default => true
  end

  def self.down
    remove_column :profiles, :show_email
    remove_column :profiles, :show_phone
    remove_column :profiles, :show_company
    remove_column :profiles, :show_title
    remove_column :profiles, :show_web_address
    remove_column :profiles, :show_address1
    remove_column :profiles, :show_address2
    remove_column :profiles, :show_state
    remove_column :profiles, :show_city
    remove_column :profiles, :show_zip
  end
end
