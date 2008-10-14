# Associate physical file locations with the unique fileinfo object, which has_many tags.
class AddFileLocationsMigration < ActiveRecord::Migration
  def self.up
    create_table :file_locations do |t|
      t.column :fileinfo_id, :integer
      t.column :location_id, :integer
      t.column :path, :string, :limit=>1024
      t.column :filename, :string, :limit=>256
    end

  end

  def self.down
    drop_table :file_locations
  end
end
