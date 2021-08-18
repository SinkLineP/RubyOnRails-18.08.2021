module FeedbackHelper
  YOUTUBE_URL = 'youtube.com'
  YOUTUBE_URL2 = 'youtu.be'
  YOUTUBE_SHARE_URL = 'https://youtu.be'
  YOUTUBE_IMAGE_STOGARE = 'https://img.youtube.com/vi'
  YOUTUBE_IMAGE_FRAME_NAME = 'hqdefault.jpg'

  def youtube?(url)
    downcase_link = url.downcase
    downcase_link.include?(YOUTUBE_URL) || downcase_link.include?(YOUTUBE_URL2)
  end

  def youtube_id(url)
    regex = /(?:.be\/|\/watch\?v=|\/(?=p\/))([\w\/\-]+)/
    url.match(regex)[1]
  end

  def youtube_video_screen(url)
    [YOUTUBE_IMAGE_STOGARE, youtube_id(url), YOUTUBE_IMAGE_FRAME_NAME].join('/')
  end

  def youtube_popup_video_url(url)
    [YOUTUBE_SHARE_URL, youtube_id(url)].join('/')
  end

end