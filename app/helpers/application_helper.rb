# Helper aplikacji
module ApplicationHelper
  # Utworzenie pomocniczego linku sortującego (parametr w url)
  def sorting_link(base_path, direction, direction_name, other_params)
    url_params = { sort_by: direction }.merge(other_params)
    url = "#{base_path}?#{url_params.to_query}"
    "<a href='#{url}'>#{direction_name}</a>".html_safe
  end
end
