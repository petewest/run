class PostsController < ApplicationController
  before_action :admin_user, only: [:create, :edit, :new, :destroy]
  before_action :get_category_from_params, only: [:edit, :show, :destroy, :update]
  def edit
  end

  def index
  end

  def new
  end

  def show
  end
end
