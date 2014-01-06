class PostsController < ApplicationController
  before_action :signed_in_user, only: [:create, :new, :preview]
  before_action :get_post_from_params, only: [:show]
  before_action :correct_user_or_admin, only: [:edit, :destroy, :update]
  def edit
  end

  def index
    if current_category
      @posts=current_category.posts.not_draft.includes(:user).page(params[:page])
    else
      @posts=Post.not_draft.includes(:user).page(params[:page])
    end
    respond_to do |format|
      format.html
      format.rss { render layout: false }
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
      if @post.draft
        flash.now[:success]="Draft saved"
        #if it's a draft, we'll stay in edit mode
        render 'edit'
      else
        flash[:success]="Post created!"
        redirect_to @post
      end
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
      if @post.draft
        flash.now[:success]="Draft saved"
        render 'edit'
      else
        flash[:success]="Post successfully updated"
        redirect_to @post
      end
    else
      flash.now[:danger]="Edit post failed"
      render 'edit'
    end
  end
  
  def preview
    #We only need the partial here, as it's an ajax request to a div
    render partial: 'shared/write_up', locals: {write_up: params[:write_up], summary: false}, layout: false
  end
  
  private
  def get_post_from_params
    @post=Post.includes(:user).find(params[:id])
  end
  def post_params
    params.require(:post).permit(:title, :write_up, :category_id, :draft, :facebook_comments)
  end
  def correct_user_or_admin
    if current_user.admin?
      @post=Post.find(params[:id])
    else
      @post=current_user.posts.find(params[:id])
    end
    redirect_to root_url if @post.nil?
  end
end
