module ApplicationHelper
  def sorting_link(base_path, direction, other_params)
    url_params = { sort_by: direction }.merge(other_params)
    url = "#{base_path}?#{url_params.to_query}"
    "<a href='#{url}'>#{direction}</a>".html_safe
  end

  def category_link(base_path, new_category)
    url_params = { category: new_category }
    url = "#{base_path}?#{url_params.to_query}"
    "<a href='#{url}'>#{new_category}</a> <br>".html_safe
  end
end
