module ApplicationHelper

  def full_title(page_title)
    base_title = "My Teaching Assistant App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def site_title
    "TA app"
  end
end
