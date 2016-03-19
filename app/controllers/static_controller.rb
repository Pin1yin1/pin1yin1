class StaticController < ApplicationController
  def about
    @active_tab = :about
    title "About Pin1yin1.com"
  end
  def links
    @active_tab = :links
    title "Links - Pin1yin1.com"
  end
end
