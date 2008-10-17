class AddLocationsMigration < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.column :type, :string, :limit=>32
      t.column :name, :string, :limit=>64
      t.column :description, :string, :limit=>256
      t.column :located, :string, :limit=>64
      t.column :location_id, :integer
    end

  end

  def self.down
    drop_table :locations
  end
end
