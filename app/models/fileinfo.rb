class Fileinfo<ActiveRecord::Base
  acts_as_taggable
  has_many :file_locations
  has_many :locations, :through=>:file_locations

  def self.add_path(location,path,opts={})
    if File.file?(path)
      pcs=path.split(/\\/)
      filename=pcs.pop
      path=pcs.join('\\')
      Fileinfo.add_file(location,path,filename,opts)
      return true
    elsif File.directory?(path)
      d=Dir.open(path)
      while d2=d.read
        next if d2=='.' || d2=='..'
        if File.directory?(File.join(d.path,d2))
          Fileinfo.add_path(location,File.join(d.path,d2),opts) if opts[:include_subdirs]
        else
          if File.file?(File.join(d.path,d2))
            Fileinfo.add_file(location,d.path,d2,opts)
          end
        end
      end
      return true
    else
      return false
    end
  end

  def self.add_file(location, path, filename, opts={})
    path_file=File.join(path,filename)
    f=File.open(path_file)
    s=Digest::SHA2.hexdigest(f.read)
    f.close
    inf=Fileinfo.find_or_create_by_sha2_and_filesize(s, File.size(path_file))
    unless opts[:tag_list].blank?
      inf.tag_list="#{inf.tag_list.blank? ? '' : inf.tag_list.join(', ')+', '}#{opts[:tag_list]}"
      inf.save
    end
    filename=Iconv.iconv('utf-8','iso-8859-1',filename).first
    path=Iconv.iconv('utf-8','iso-8859-1',path).first
    FileLocation.find_or_create_by_fileinfo_id_and_location_id_and_path_and_filename(inf.id,location.id,path,filename) if inf
  end
end
