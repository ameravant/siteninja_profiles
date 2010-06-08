class AddPersonIdToProfiles < ActiveRecord::Migration
  def self.up
    create_table "profiles", :force => true do |t|
      t.integer :person_id
      t.string :permalink
      t.boolean :public, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
