module ActivitiesHelper
  def gmaps_api_key
    "AIzaSyBn59e0xUZcNRyxjJljFE0bHqMvHqSt4H4"
  end
  
  def map_for_activity_static(id, options={})
    begin
      activity=Activity.find(id)
    rescue ActiveRecord::RecordNotFound => e
      return ""
    end
    url="//maps.googleapis.com/maps/api/staticmap?visual_refresh=true&maptype=terrain&size=600x400&path=weight:3%7Ccolor:red%7Cenc:#{activity.polyline}&sensor=false"
    opts=" "
    options.each {|k,v| opts+="#{k.to_s}='#{v}' " }
    %Q{<img#{opts}src="#{url}" />}
  end

  def map_for_activity_redcloth(id, static=true, options= {})
    #So we can customise redcloth specific things if we want, without breaking any other map link
    if static
      map_for_activity_static(id, options)
   else
      map_for_activity_dynamic(id, options)
   end
  end
  
  def map_for_activity(id, options={})
    map_for_activity_redcloth(id,options).html_safe
  end
  
  def map_for_activity_dynamic(id, options={})
    begin
      activity=Activity.find(id)
    rescue ActiveRecord::RecordNotFound => e
      return ""
    end
    opts=" "
    options.each {|k,v| opts+="#{k.to_s}='#{v}' " }
    html=%Q{<div#{opts}id="map-canvas-#{id}" class="map-canvas">}
    html+=%Q{</div>}
  end

  def google_maps_js
    # Adds google map js code to the bottom of the page
    # but we'll only add it if we actually need a map on screen
    # and if we do, we only want to do it once
    html=%Q{<script type="text/javascript"}
    html+=%Q{ src="//maps.googleapis.com/maps/api/js}
    html+=%Q{?key=#{gmaps_api_key}}
    html+=%Q{&libraries=geometry&sensor=false">}
    html+=%Q{</script>}
  end
end
