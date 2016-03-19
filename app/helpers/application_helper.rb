module ApplicationHelper
  def tab(key, name, url_parameters)
    link_to name, url_parameters, {:class => @active_tab == key ? "active" : ""}
  end
end
