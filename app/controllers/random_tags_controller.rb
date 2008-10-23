class RandomTagsController < ApplicationController

  def show
    if params[:id]
      @fileinfo=Fileinfo.find(params[:id])
    else
      if params[:only_untagged]
        untagged=Fileinfo.find(:all, :select=>"fileinfos.*,count(tgg.id) as anz", :joins=>"left join taggings tgg on tgg.taggable_type='Fileinfo' AND tgg.taggable_id=fileinfos.id", :group=>'fileinfos.id having anz=0')
        if untagged.length>0
          r=(rand*untagged.length-1).round
          return @fileinfo=untagged[r]
        end
      end
      
      mx,r=Fileinfo.count,0
      return if mx==0
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
    redirect_to :action=>:show, :only_untagged=>params[:only_untagged]
  end
end
