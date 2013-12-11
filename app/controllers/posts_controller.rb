class PostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :new]
  before_action :get_post_from_params, only: [:show]
  before_action :correct_user, only: [:edit, :destroy, :update]
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
      flash.now[:danger]="Error creating post"
      render 'new'
    end
  end
  
  def destroy
    @post.destroy
    flash[:success]="Post deleted!"
    redirect_to posts_path
  end
  
  def update
    if @post.update_attributes(post_params)
      flash[:success]="Post successfully updated"
      redirect_to @post
    else
      flash.now[:danger]="Edit post failed"
      render 'edit'
    end
  end
  
  private
  def get_post_from_params
    @post=Post.find(params[:id])
  end
  def post_params
    params.require(:post).permit(:title, :embed_code, :at, :write_up, :category_id)
  end
  def correct_user
    @post=current_user.posts.find(params[:id])
    redirect_to root_url if @post.nil?
  end
end
