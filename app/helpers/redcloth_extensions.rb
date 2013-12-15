module RedclothExtensions
  include ActivitiesHelper
  
  def map(opts)
    activity, align=opts[:text].split('|').map {|str| str.strip}
    css="activity_map"
    css+=" pull-right" if align=="right"
    url=map_for_activity_redcloth(activity, class: css)
    puts url
    html= %Q{#{url}}
  end
end