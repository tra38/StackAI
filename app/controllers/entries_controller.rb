class EntriesController < ApplicationController
  def index
    @entries = Entry.paginate(:page => params[:page], :per_page => 10)
    @feeds = Feed.all
  end

end
