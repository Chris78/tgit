class FilesController < ApplicationController
  def get
    if File.exists?(params[:path])
      send_file(params[:path], :disposition=>'inline', :content_type=>'image') and return false
    else
      send_file('public/images/unavailable.gif',:disposition=>'inline', :content_type=>'image/gif') and return false
    end
  end

  def index
    @match_all = params[:match_all]
    @fileinfos=Fileinfo.find_tagged_with(params[:tagged_with], :match_all=>@match_all).paginate(:per_page=>5, :page=>params[:page])
    deeper_tags=[]
    @fileinfos.each do |i|
      deeper_tags += i.tag_list
    end
    deeper_tags.uniq!
    deeper_tags=deeper_tags-((params[:tagged_with]||'').split(',').map{|i| i.strip}.reject{|j| j.blank?})
    @tags=Fileinfo.tag_counts(:conditions=>"tags.name in ('#{deeper_tags.join("','")}')")
    @tags=Fileinfo.tag_counts if @tags.blank?
  end

end
