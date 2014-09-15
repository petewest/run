class HitsController < ApplicationController
  before_action :admin_user

  def index
    @hits = Hit.page(params[:page])
  end
end
