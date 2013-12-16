module RedclothExtensions
  include ActivitiesHelper
  
  def map(opts)
    args=/\A(?<static>[s]?)(?<align>[<|>]?)\s*(?<id>\d+)\s*(?<caption>.*)/.match(opts[:text].html_safe)
    return "" if args.nil?
    css="activity_map"
    css+=case args[:align]
      when "|" then " center"
      when ">" then " pull-right"
      else " pull-left"
    end
    html=%Q{<div class="#{css}" id="map-container-#{args[:id]}">}
    html+=map_for_activity_redcloth(args[:id], args[:static].blank? ? false : true)
    html+=%Q{<div class="map-caption">#{args[:caption]}</div>} unless args[:caption].blank?
    html+=%Q{</div>}
  end
end
