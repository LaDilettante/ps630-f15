module ApplicationHelper

  def full_title(page_title)
    base_title = "POLSCI 630"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def site_title
    "POLSCI 630"
  end

  def parse_time_with_correct_zone(input_string)
    input_format = "%m/%d/%Y %H:%M"
    datetime_with_wrong_zone = DateTime.strptime(input_string, input_format)
    correct_datetime = Time.zone.parse(datetime_with_wrong_zone.strftime('%Y-%m-%d %H:%M:%S'))
    correct_datetime
  end
end
