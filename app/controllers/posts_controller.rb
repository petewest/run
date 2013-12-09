class PostsController < ApplicationController
  before_action :admin_user, only: [:create, :edit, :new, :destroy]
  before_action :get_post_from_params, only: [:edit, :show, :destroy, :update]
  def edit
  end

  def index
    if current_category
      @posts=current_category.posts.paginate(page: params[:page])
    else
      @posts=Post.paginate(page: params[:page])
    end
  end

  def new
    @post=Post.new
  end

  def show
  end
  
  def create
    @post=current_user.posts.create(post_params)
    if @post.save
      flash[:success]="Post created!"
      redirect_to @post
    else
      flash.now[:error]="Error creating post"
      render 'new'
    end
  end
  
  def destroy
  end
  
  private
  def get_post_from_params
    @post=Post.find(params[:id])
  end
  def post_params
    params.require(:post).permit(:title, :embed_code, :at, :write_up, :category_id)
  end
end
