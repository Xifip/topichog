module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)  
    base_title = "Topichog"
    if page_title.empty?
      base_title
    else     
      "#{base_title} | #{page_title}"
    end
  end
  
    # Returns the full meta on a per-page basis.
  def full_meta(page_meta)  
    base_meta = "Topichog"
    if page_meta.empty?
      base_meta
    else     
      "#{base_meta} | #{page_meta}"
    end
  end

end

