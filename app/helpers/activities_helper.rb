module ActivitiesHelper
  def gmaps_api_key
    "AIzaSyBn59e0xUZcNRyxjJljFE0bHqMvHqSt4H4"
  end
  
  def map_for_activity_base(id, options={})
    begin
      activity=Activity.find(id)
    rescue ActiveRecord::RecordNotFound => e
      return
    end
    url="http://maps.googleapis.com/maps/api/staticmap?visual_refresh=true&maptype=terrain&size=600x400&path=weight:3%7Ccolor:red%7Cenc:#{activity.polyline}&sensor=false"
    opts=" "
    options.each {|k,v| opts+="#{k.to_s}='#{v}' " }
    %Q{<img#{opts}src="#{url}" />}
  end

  def map_for_activity_redcloth(id, options={})
    #So we can customise redcloth specific things if we want, without breaking any other map link
    map_for_activity_base(id, options)
  end
  
  def map_for_activity(id, options={})
    map_for_activity_redcloth(id,options).html_safe
  end
end
