class InputController < ApplicationController
  def new
    @locations=Location.find(:all)
  end
  def create
    if !File.directory?(params[:path])
      redirect_to :action=>'new', :location_id=>params[:location_id], :message=>"Der angegebene Pfad ist nicht erreichbar!"
    else
      loc=Location.find(params[:location_id])
      opts={:include_subdirs=>params[:include_subdirs], :tag_list=>params[:tag_list]}
      Fileinfo.add_path(loc,params[:path],opts)
      redirect_to :action=>:new, :location_id=>params[:location_id], :message=>"Dateien aus #{params[:path]} erfolgreich eingetragen"
    end
  end
end
