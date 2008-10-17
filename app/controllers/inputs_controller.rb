class InputsController < ApplicationController
  def new
    @locations=Location.find(:all)
  end
  def create
    path_utf8,path_iso = params[:path],Iconv.iconv('iso-8859-1','utf-8',params[:path]).first
    if !File.directory?(path_iso)
      redirect_to :action=>'new', :location_id=>params[:location_id], :message=>"Der angegebene Pfad ist nicht erreichbar!"
    else
      loc=Location.find(params[:location_id])
      opts={:include_subdirs=>params[:include_subdirs], :tag_list=>params[:tag_list]}
      Fileinfo.add_path(loc,path_iso,opts)
      redirect_to :action=>:new, :location_id=>params[:location_id], :message=>"Dateien aus #{path_utf8} erfolgreich eingetragen"
    end
  end
end
