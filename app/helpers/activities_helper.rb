module ActivitiesHelper
  def gmaps_api_key
    "AIzaSyBn59e0xUZcNRyxjJljFE0bHqMvHqSt4H4"
  end
  
  def map_for_activity(id, options={})
    activity=Activity.find(id)
    if activity
      url="http://maps.googleapis.com/maps/api/staticmap?visual_refresh=true&maptype=terrain&size=600x400&path=weight:3%7Ccolor:red%7Cenc:#{activity.polyline}&sensor=false"
      opts=" "
      options.each {|k,v| opts+="#{k.to_s}='#{v}' " }
      "<img#{opts}src='#{url}' />".html_safe
    end
  end
end
