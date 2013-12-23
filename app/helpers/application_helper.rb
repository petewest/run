module ApplicationHelper
  def full_title(stub='')
    title="Run for the hills"
    title+=" | #{stub}" unless stub.blank?
    title
  end
end
