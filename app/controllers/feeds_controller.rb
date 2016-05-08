class FeedsController < ApplicationController

  def index
    @categories = Category.all
    @feeds = Feed.all
  end

  def show
    @feed = Feed.find(params[:id])
    @entries = @feed.entries.paginate(:page => params[:page], :per_page => 10)
  end

end
