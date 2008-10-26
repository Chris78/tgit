class FilesController < ApplicationController
  def get
    if File.exists?(params[:path])
      send_file(params[:path], :disposition=>'inline', :content_type=>'image') and return false
    else
      send_file('public/images/no_disk.gif',:disposition=>'inline', :content_type=>'image/gif') and return false
    end
  end

  def index
    @match_all = params[:match_all]
    @fileinfos=Fileinfo.find_tagged_with(params[:tagged_with], :match_all=>@match_all)
    deeper_tags=[]
    @fileinfos.each do |i|
      deeper_tags += i.tag_list
    end
    deeper_tags.uniq!
    tagged_with=(params[:tagged_with]||'').split(',').map{|i| i.strip}#.reject{|j| j.blank?}
    @fileinfos=@fileinfos.paginate(:per_page=>5, :page=>params[:page])
    @tags=Fileinfo.tag_counts(:conditions=>"tags.name IN ('#{deeper_tags.join("','")}') AND tags.name NOT IN ('#{tagged_with.join("','")}')")
    @tags=Fileinfo.tag_counts if @tags.blank?
    @tags.sort!{|t1,t2| t1.name.downcase<=>t2.name.downcase}
  end

end
