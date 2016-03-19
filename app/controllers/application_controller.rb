class ApplicationController < ActionController::Base
  protect_from_forgery

  def title(t)
    @title = t
  end
end
