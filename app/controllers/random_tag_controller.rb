class RandomTagController < ApplicationController

  def show
    if params[:id]
      @fileinfo=Fileinfo.find(params[:id])
    else
      mx,r=Fileinfo.count,0
      while r==0 or r==mx do
        r=(rand*mx).round
      end
      @fileinfo=Fileinfo.find(:first, :limit=>1, :offset=>r)
    end
  end

  def update
    if inf=Fileinfo.find(params[:id])
      inf.update_attributes(params[:fileinfo])
    end
    redirect_to :action=>:show
  end
end
