xml.instruct! :xml, version: '1.0'
xml.tag! 'yml_catalog', date: Time.current.strftime('%Y-%m-%d %H:%M') do

  xml.shop do
    xml.name 'Дом Русской Косметики'
    xml.company 'АНО ДПО "Институт косметологии, эстетической медицины и визажного искусства – Дом Русской Косметики"'
    xml.url root_url
  end

  xml.cpa 1

  xml.offers do
    @promotions.each do |promotion|
      xml.offer id: promotion.feed_id, available: promotion.visible do
        xml.name promotion.title
        xml.url promotion.link
        xml.description promotion.announce
        xml.picture promotion.image? ? URI.join(root_url, promotion.image_url(:main)) : asset_url('courses_shop/page_promo/page_promo_index.jpg')
        xml.promo true
      end
    end
  end

end