class LocationController < ApplicationController
  def index
    @locations=Location.find(:all)
  end
  def create
    params[:location][:type].constantize.create(params[:location])
    redirect_to :action=>'index'
  end
  def delete
    Location.delete(params[:id])
    redirect_to :action=>:index
  end
end
