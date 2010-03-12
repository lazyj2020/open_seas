class SiteController < ApplicationController

  def index
    @title = "Welcome to the Open Seas"
  end

  def help
    @title = "Help"
  end

  def about
    @title = "About the Open Seas"
  end

  def denied
    @title = "DENIED"
  end

end
