module PostHelper

  def month_names
    [nil, 'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь']
  end

  def post_date(date)
    Russian.strftime(date, '%d %B %Y') if date
  end

  def post_image_tag(post)
    image_tag post.announcement_image_url(:preview) || 'post_image.png', alt: post.try(:title).try(:html_safe), class: 'blog_post-img', width: 328, height: 217
  end

  def active_button_class(filter)
    @filter == filter ? 'active' : nil
  end

  def active_select_class
    (@filter != 'popular' && @filter != 'newest') ? 'active' : nil
  end

  def month_select_options
    today = Date.today
    months = [today.month]
    1.upto(Post::LAST_MONTHS_COUNT - 1) { |i| months << (today - i.month).month }

    months_choices = months.reverse.map do |month|
      option_value = "in_#{Date::MONTHNAMES[month].downcase}"
      option_text = "ЗА #{month_names[month].mb_chars.upcase}"
      [option_text, option_value]
    end

    options_for_select(months_choices, @filter)
  end

  def has_blog_subscription?
    current_user.try(:has_blog_subscription?) || session[:has_blog_subscription]
  end

end
