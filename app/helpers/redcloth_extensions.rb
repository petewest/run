module RedclothExtensions
  include ActivitiesHelper
  
  def map(opts)
    args=/\A(?<static>[s]?)(?<align>(&gt;|&lt;|\|)?)\s*(?<id>\d+)\s*(?<caption>.*)/.match(opts[:text])
    return "" if args.nil?
    css="activity_map"
    css+=case args[:align]
      when "|" then " center"
      when "&gt;" then " pull-right"
      else " pull-left"
    end
    html=%Q{<div class="#{css}" id="map_container_#{args[:id]}">}
    html+=map_for_activity_redcloth(args[:id], args[:static].blank? ? false : true)
    html+=%Q{<div class="map_caption">#{args[:caption]}</div>} unless args[:caption].blank?
    html+=%Q{</div>}
  end
end
