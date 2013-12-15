module ActivitiesHelper
  def gmaps_api_key
    "AIzaSyBn59e0xUZcNRyxjJljFE0bHqMvHqSt4H4"
  end
  def map_for(id)
    activity=Activity.find(id)
    "<img src='http://maps.googleapis.com/maps/api/staticmap?visual_refresh=true&maptype=terrain&size=600x400&path=weight:3%7Ccolor:red%7Cenc:#{activity.polyline}&sensor=false' />".html_safe if activity
  end
end
