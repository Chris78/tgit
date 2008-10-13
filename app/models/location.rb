class Location<ActiveRecord::Base
  has_many :file_locations, :dependent=>:destroy

  def full_name
    s=self.name
    l=self
    while l.location do
      l=l.location
      s+=' -> '+l.name
    end
    return s
  end
end
