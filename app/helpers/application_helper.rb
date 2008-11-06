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

  def text_field_will_auto_complete(object_name,field,url,options={})
    field_name = field ? "#{object_name}[#{field}]" : object_name
    field_id = options[:id]|| (field ? "#{object_name}_#{field}" : object_name)
    div_id="ac_results_#{field_id}"
    options={
      :id=>field_id,
      :name=>field_name,
      :class=>"ujs_autocomplete #{options.delete(:class)}",
      :url=>url,
      :method=>'get',
      :update=>div_id,
      :param_name=>options[:param_name]||field_name,
      :tokens=>', ',
      :focus => true,
      :autocomplete=>'off',
      :onkeydown=>"if(event.keyCode==Event.KEY_RETURN){Event.stop(event); return false;}", # <-- Wichtig, damit das Formular NICHT direkt abgeschickt wird, sondern über den AutoCompleter!
      :auto_submit=>'true'
    }.merge(options)

    # Wenn field = '' gibt text_field einen Fehler aus und da ID und Name eh über die Optionen gestezt werden, sollte das hier kein Problem sein
    input  = text_field(nil, nil, options)
    output = "<div id='#{div_id}' input_field='#{field_id}' class='ac_results hidden' ></div>"
    return input+output
  end

end
