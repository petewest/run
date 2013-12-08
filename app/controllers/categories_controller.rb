class CategoriesController < ApplicationController
  before_action :admin_user
  before_action :get_category_from_params, only: [:show, :edit, :update, :destroy]
  def new
    @category = Category.new
  end

  def index
    @categories = Category.all
  end

  def show
    #Nothing needed here due to before_action
  end

  def edit
    #Nothing needed here due to before_action
  end
  
  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success]="New category created"
      redirect_to category_path(@category)
    else
      render 'new'
    end
  end
  
  def update
    #before_action makes sure we've got a category
    if @category.update_attributes(category_params)
      flash[:success]="Category updated"
      redirect_to @category
    else
      flash.now[:error]="Update failed"
      render 'edit'
    end
  end
  
  def destroy
    #before_action makes sure we've got a category
    @category.destroy
    flash[:success]="Category deleted"
    redirect_to categories_path
  end
  
  private
  def category_params
    params.require(:category).permit(:name, :stub, :sort_order)
  end
  def get_category_from_params
    @category=Category.find(params[:id])
  end
end
