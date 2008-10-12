class LocationController < ApplicationController
  def index
    @locations=Location.find(:all)
  end
end
