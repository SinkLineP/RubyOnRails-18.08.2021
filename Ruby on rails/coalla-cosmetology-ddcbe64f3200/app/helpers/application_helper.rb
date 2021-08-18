module ApplicationHelper

  def page_title
    if @page_title.is_a?(Array)
      @page_title.reverse.join(' | ')
    else
      @page_title.presence || 'Дом Русской Косметики'
    end
  end

  def asset_exists?(subdirectory, filename)
    File.exists?(File.join(Rails.root, 'app', 'assets', subdirectory, filename))
  end

  def javascript_exists?(script)
    extensions = %w(.coffee .erb .coffee.erb) + [""]
    extensions.inject(false) do |truth, extension|
      truth || asset_exists?('javascripts', "#{script}.js#{extension}")
    end
  end

  def ya_counter_click(id)
    "yaCounter20442787.reachGoal('#{id}'); return true;" if Rails.env.production?
  end

  def format_date(date)
    return '' unless date
    Russian.strftime(date, '%d.%m.%Y')
  end

  def format_date_st(date)
    return '' unless date
    Russian.strftime(date, '%d.%m.%y')
  end

  def format_date_time_full(date, delimiter = '.')
    return '' unless date
    Russian.strftime(date, "%d#{delimiter}%m#{delimiter}%Y %H:%M:%S")
  end

  def format_date_with_time(datetime)
    return '' unless datetime
    Russian.strftime(datetime, '%d %B %Y %H:%M')
  end

  def format_date_full(datetime)
    return '' unless datetime
    Russian.strftime(datetime, '%d %B %Y')
  end

  def format_date_short(date)
    return '' unless date
    Russian.strftime(date, '%e %B')
  end

  def month_year_format(date)
    return '' unless date
    Russian.strftime(date, '%d.%m')
  end

  def format_time(time)
    return '' unless time
    Russian.strftime(time, '%H:%M')
  end

  def feed_date_format(date, delimiter = '.')
    return '' unless date
    Russian.strftime(date, "%Y#{delimiter}%m#{delimiter}%d")
  end

  def full_image_url(image_url)
    URI.join(root_url, image_url)
  end

  def month_options
    (1..12).to_a.map { |i| ["#{i} #{Russian.p(i, 'месяц', 'месяца', 'месяцев')}", i] }
  end

  def current_static_page?(slug)
    current_page?(static_page_path(slug))
  end

  def display_current_role
    current_user.class.model_name.human
  end

  def display_result_name(result)
    "Задание #{result.task.lecture.position} (#{result.task.class.model_name.human})"
  end

  def practice_range_text(practice)
    practice.begin_on == practice.end_on ? format_date(practice.begin_on) : format_date(practice.begin_on) + '-' + format_date(practice.end_on)
  end

  def placeholder_url(version)
    "https://placehold.it/#{version}?text=∴"
  end

  def ty_html(text)
    return '' unless text.presence
    ty(text).html_safe
  end

  def safe_html_content(html)
    return '' unless html.present?
    html.html_safe
  end

  def format_price(price)
    roubles = price.floor
    pennies = ((price - roubles) * 100).round
    "#{roubles} #{Russian.p(roubles, 'рубль', 'рубля', 'рублей')} #{'%02d' % pennies} #{Russian.p(pennies, 'копейка', 'копейки', 'копеек')}"
  end

  def feed_start_group_date(group)
    fake_group = group.blank? || group.fake
    education_dates = group ? group.education_dates : []
    fake_group ? '' : feed_date_format(education_dates[0])
  end

  def transparent_pixel
    'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII='
  end

  def title_with_page(title, page)
    result = I18n.t("page_titles.#{title}")
    return result if page.blank?

    "#{result} - Страница #{page}"
  end
end
