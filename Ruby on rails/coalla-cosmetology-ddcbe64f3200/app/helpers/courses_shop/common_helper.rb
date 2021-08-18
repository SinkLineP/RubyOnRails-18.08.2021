module CoursesShop
  module CommonHelper
    def courses_shop_favicon
      favicon_link_tag "courses_shop/favicons/#{current_shop.code}.png"
    end

    def pagination_complex(items, append_to, pages = true)
      render 'courses_shop/common/pagination_complex', items: items, append_to: append_to, pages: pages
    end

    def embedded_url(video_link)
      return '' if video_link.blank?
      return '' if !(video_link.include?('youtube') || video_link.include?('youtu.be') || video_link.include?('vimeo'))
      video_id = video_link.split('/').last.to_s.split('=').last
      return "https://www.youtube.com/embed/#{video_id}" if (video_link.include?('youtube') || video_link.include?('youtu.be'))
      return "https://player.vimeo.com/video/#{video_id}" if video_link.include?('vimeo')
    end

    def gtm_id_for_shop
      current_shop.barbershop? ? 'GTM-N3X8VZH' : 'GTM-NTXZJ5F'
    end

    def banner_url_params
      result = {}
      %i(utm_campaign utm_content utm_medium utm_source utm_term roistat_marker).each do |key|
        next unless cookies[key].present?
        result[key] = cookies[key]
      end
      result.to_query
    end

    def additional_banner_params
      banner_url_params.present? ? "?#{banner_url_params}" : ''
    end
  end
end