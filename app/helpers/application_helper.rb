# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper

  def location_selector(locations,options={})
    include_blank=options[:include_blank]||false
    render :partial=>'shared/select_location', :locals=>options.update(:locations=>locations, :include_blank=>include_blank)
  end

  def icon(name)
    image_tag('/images/'+name+'.gif', :border=>:none)
  end

end
