class HitsController < ApplicationController
  before_action :find_post_from_post_id
  before_action :signed_in_user

  def index
    @hits = Hit
    @hits = current_user.hits unless is_admin?
    @hits = @hits.where(hittable: @post) if @post
    @hits = @hits.page(params[:page])
  end

  private
    def find_post_from_post_id
      @post = Post.find(params[:post_id]) if params[:post_id]
    end
end
