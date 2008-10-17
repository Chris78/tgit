class FileLocationsController < ApplicationController
  def new
  end
  def delete
    FileLocation.delete(params[:id])
    render :nothing=>true
  end
end
