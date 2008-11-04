class FilesController < ApplicationController
  def get
    require 'sqlite3'
    db = SQLite3::Database.new("db/tgit_thumbs.db")
    data=nil
    query="select data from thumbs where fileinfo_id="+params[:fileinfo_id]+' limit 1'
    db.execute(query) do |row|
      data=row
    end
    db.close
    send_data(data) and return false if data

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
