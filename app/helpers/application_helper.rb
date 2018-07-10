module ApplicationHelper
  def full_title page_title = ""
    base_title = t "title-1"
    page_title.empty? ? base_title : page_title + " | " +base_title
  end
end
