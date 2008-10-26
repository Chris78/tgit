class LocationsController < ApplicationController
  before_filter :set_menu
  def index
    @locations=Location.find(:all)
    select_menu('manage')
  end
  def create
    params[:location][:type].constantize.create(params[:location])
    redirect_to :action=>'index'
  end
  def delete
    Location.delete(params[:id])
    redirect_to :action=>:index
  end

  def browse
    select_menu('browse')
    @location=Location.find(params[:location_id]) unless params[:location_id].blank?
    @locations=Location.all(:conditions=>"type NOT IN ('Computer','HddCase')")
    conds=[]
    conds += params[:filter_filename].split(/\s+/).map{|x| "file_locations.filename LIKE \"%#{x}%\""} unless params[:filter_filename].blank?
    conds += params[:filter_path].split(/\s+/).map{|x| "file_locations.path LIKE \"%#{x}%\""} unless params[:filter_path].blank?
    conds << "file_locations.location_id=#{@location.id}" if @location
    unless conds.blank?
      @fileinfos=Fileinfo.paginate(:include=>:file_locations, :conditions=>conds.join(' AND '), :per_page=>params[:per_page]||10, :page=>params[:page])
    end
  end

  private

  def set_menu
    menu_add('Locations verwalten', '/locations', :id=>'manage')
    menu_add('Locations durchsuchen', '/locations/browse', :id=>'browse')
    #menu_add('Location-Details bearbeiten', '/locations/edit', :id=>'edit')
    menu_add('Location-Details bearbeiten', '#', :onclick=>"alert('Kommt auch bald...'); return false", :id=>'edit')
  end
  def menu_add(name,url,options={})
    @menu||=[]
    @menu<<{:name=>name, :url=>url, :html_options=>options}
  end
  def select_menu(id)
    @selected=id
  end
end
