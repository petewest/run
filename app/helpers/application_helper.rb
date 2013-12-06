module ApplicationHelper
  def full_title(stub='')
    title="Run for your life"
    title+=" | #{stub}" unless stub.blank?
    title
  end
end
