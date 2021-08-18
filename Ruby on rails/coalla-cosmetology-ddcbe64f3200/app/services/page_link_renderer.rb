class PageLinkRenderer < WillPaginate::ActionView::LinkRenderer

  protected

  def html_container(html)
    tag(:ul, html, class: 'page_nav')
  end

  def page_number(page)
    if page == current_page
      tag(:li, tag(:a, page), class: 'page_nav-i active')
    else
      tag(:li, link(page, page, rel: rel_value(page)), class: 'page_nav-i')
    end
  end

  def gap
    text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
    tag(:li, tag(:a, text), class: 'page_nav-i')
  end

  def previous_page
  end

  def next_page
  end

end