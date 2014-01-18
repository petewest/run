module RedclothExtensions
  include ActivitiesHelper
  include AttachmentsHelper

  def map(opts)
    args=match_format.match(opts[:text])
    return opts[:text] if args.nil?
    css="activity_map"
    css+=align(args[:align])
    html=%Q{<div class="#{css}" id="map_container_#{args[:id]}">}
    html+=map_for_activity_redcloth(args[:id], args[:static].blank? ? false : true)
    html+=%Q{<div class="map_caption">#{args[:caption]}</div>} unless args[:caption].blank?
    html+=%Q{</div>}
  end
  
  def img(opts)
    args=match_format.match(opts[:text])
    return opts[:text] if args.nil?
    css="post_image"
    css+=align(args[:align])
    html=%Q{<div class="#{css}" id="image_container_#{args[:id]}">}
    html+= attachment_image(args[:id])
    html+=%Q{<div class="image_caption">#{args[:caption]}</div>} unless args[:caption].blank?
    html+=%Q{</div>}
  end
  
  def graph(opts)
    args=match_format.match(opts[:text])
    return opts[:text] if args.nil?
    css="graph_container"
    css+=align(args[:align])
    html=%Q{<div class="#{css}" id="graph_container_#{args[:id]}">}
    html+=graph_for_activity(args[:id])
    html+=%Q{</div>}
  end
  
  private
  def match_format
    /\A(?<static>[s]?)(?<align>(&gt;|&lt;|\|)?)\s*(?<id>\d+)\s*(?<caption>.*)/
  end
  
  def align(indicator)
    case indicator
      when "|" then " center"
      when "&gt;" then " pull-right"
      else " pull-left"
    end
  end
end
