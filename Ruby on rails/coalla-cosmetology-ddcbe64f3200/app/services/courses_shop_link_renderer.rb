class CoursesShopLinkRenderer < WillPaginate::ActionView::LinkRenderer
  protected

  def html_container(html)
    tag(:div, tag(:ul, html), class: 'pagination__pages')
  end

  def page_number(page)
    inner_html = page == current_page ? tag(:span, page) : link(page, page, rel: rel_value(page))
    tag(:li, inner_html.html_safe)
  end

  def gap
    inner_html = tag(:span, @template.will_paginate_translate(:page_gap) { '&hellip;' })
    tag(:li, inner_html.html_safe)
  end

  def previous_page
    num = @collection.current_page > 1 && @collection.current_page - 1
    previous_or_next_page(num, 'arrow-left')
  end

  def next_page
    num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
    previous_or_next_page(num, 'arrow-right')
  end

  def previous_or_next_page(page, icon)
    icon_html = tag(:svg,
                    tag(:use, nil, 'xlink:href' => "/assets/courses_shop/icons.svg##{icon}"),
                    class: 'icon',
                    role: 'img',
                    'data-size' => 18)
    inner_html = page ? link(icon_html.html_safe, page, class: 'pagination__item') :
        tag(:span, icon_html, class: 'pagination__item')
    tag(:li, inner_html.html_safe, class: 'is-nav')
  end
end