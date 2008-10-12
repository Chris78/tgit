class Location<ActiveRecord::Base
  belongs_to :file_location

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
