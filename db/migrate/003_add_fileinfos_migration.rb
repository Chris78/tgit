class AddFileinfosMigration < ActiveRecord::Migration
  def self.up
    create_table :fileinfos, :options=>'default charset=utf8' do |t|
      t.column :sha2, :string, :limit=>64
      t.column :filesize, :integer, :limit=>8 # ?  check this... Should be enough Bytes for a 10 GB File (or something like that)
    end

  end

  def self.down
    drop_table :fileinfos
  end
end
