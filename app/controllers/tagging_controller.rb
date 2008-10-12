class TaggingController < ApplicationController
  def delete
    obj=params[:taggable_type].constantize.find(params[:taggable_id])
    tags=obj.tags.reject{|t| t.id==params[:tag_id].to_i}
    obj.tag_list=tags.map{|t| t.name}.join(',')
    obj.save
    render :nothing=>true
  end

  def add
    obj=params[:taggable_type].constantize.find(params[:taggable_id])
    tags=obj.tags.reject{|t| t.id==params[:tag_id].to_i}
    obj.tag_list= obj.tag_list.to_s+', '+params[:tag_names]
    obj.save
    dom_id="tags_for_#{obj.class.to_s}_#{obj.id}"
    render :update do |page|
      page.replace dom_id, :partial=>'shared/tags', :locals=>{:obj=>obj}
    end
  end
end
