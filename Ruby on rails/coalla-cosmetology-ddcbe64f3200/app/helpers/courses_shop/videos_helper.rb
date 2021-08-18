module CoursesShop
  module VideosHelper
    def jw_player_options(video, options = {})
      {
        file: video.file_url,
        width: options[:width].presence || 560,
        height: options[:height].presence || 315,
        image: video.preview_image.url(:main),
        aspectratio: '16:9'
      }.to_json
    end

    def replace_video_links(content)
      return '' unless content.present?
      doc = Nokogiri::HTML.parse(content)
      doc.css('.js-videos-pin').each do |link|
        id = link['data-id'].to_i
        model = link['data-type'].constantize
        video = model.find(id)
        video_html = render('courses_shop/common/jw_player_video', video: video) if video
        link.replace(video_html.to_s)
      end
      doc.at('body').inner_html.html_safe if doc.at('body').present?
    end
  end
end
