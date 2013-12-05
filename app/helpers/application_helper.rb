module ApplicationHelper
  def full_title(stub='')
    title="Running for your life"
    title+=" | #{stub}" unless stub.blank?
    title
  end
end
