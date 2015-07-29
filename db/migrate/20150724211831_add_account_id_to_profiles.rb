class AddAccountIdToProfiles < ActiveRecord::Migration
  def self.up
  	add_column :profiles, :account_id, :integer, :default => 1
    add_column :profiles, :master, :boolean, :default => false
  end

  def self.down
  end
end
