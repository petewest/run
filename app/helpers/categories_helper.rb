module CategoriesHelper
  def all_categories
    @all_categories||=Category.all
  end
  def current_category
    @current_category||=Category.find_by_stub(params[:category])
  end
end
