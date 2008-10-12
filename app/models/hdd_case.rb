class HddCase<Location
  has_many :harddisks, :foreign_key=>:location_id
  belongs_to :location
end
