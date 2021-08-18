class CreateMetaTags < ActiveRecord::Migration
  def up
    create_table :meta_tags do |t|
      t.text :identifier, null: false
      t.index :identifier, unique: true

      t.text :site, null: false, default: ''
      t.text :title, null: false, default: ''
      t.text :description, null: false, default: ''
      t.text :image
      t.text :url
      t.text :keywords

      t.text :og_title
      t.text :og_description
      t.text :og_image
      t.text :og_url

      t.timestamps
    end

    SiteMetaTags.create!(identifier: :default, title: 'Учебный Центр - подготовка профессионалов', site: 'Дом Русской Косметологии',
                         description: 'Предлагаем вам курсы парикмахеров и косметологов. Курсы маникюра, педикюра, наращивания ногтей, макияжа, массажа. Дистанционное и очное обучение',
                         keywords: '', image: File.open(Rails.root.join('app/assets/images/share.jpg')),
                         og_title: 'Учебный Центр - подготовка профессионалов', og_description: 'Предлагаем вам курсы парикмахеров и косметологов. Курсы маникюра, педикюра, наращивания ногтей, макияжа, массажа. Дистанционное и очное обучение',
                         og_image: File.open(Rails.root.join('app/assets/images/share.jpg')))
    SiteMetaTags.create!(identifier: '/about', title: 'Об Институте косметологии, эстетической медицины.', og_title: 'Об Институте косметологии, эстетической медицины.',
                         description: 'Официальном сайте Института косметологии, эстетической медицины и визажного искусства — Дом Русской Косметики',
                         og_description: 'Официальном сайте Института косметологии, эстетической медицины и визажного искусства — Дом Русской Косметики')
    SiteMetaTags.create!(identifier: '/info', title: 'Сведения об образовательной организации', og_title: 'Сведения об образовательной организации',
                         description: 'Сведения об образовательной организации Дома русской косметологии',
                         og_description: 'Сведения об образовательной организации Дома русской косметологии')
    SiteMetaTags.create!(identifier: '/contacts', title: 'Контакты', og_title: 'Контакты',
                         description: 'Контакты института косметологии, эстетической медицины и визажного искусства',
                         og_description: 'Контакты института косметологии, эстетической медицины и визажного искусства')
    SiteMetaTags.create!(identifier: '/promotions', title: 'Акции и скидки на обучение в Доме Русской Косметологии', og_title: 'Акции и скидки на обучение в Доме Русской Косметологии',
                         description: 'В Доме Русской Косметологии действуют постоянные скидки на обучение косметологов, парикмахеров, мастеров маникюра, макияжа и татуажа, а также массажистов.',
                         og_description: 'В Доме Русской Косметологии действуют постоянные скидки на обучение косметологов, парикмахеров, мастеров маникюра, макияжа и татуажа, а также массажистов.')
    SiteMetaTags.create!(identifier: '/license', title: 'Лицензии', og_title: 'Лицензии',
                         description: 'Образовательные и медицинские лицензии Дома Русской Косметологии',
                         og_description: 'Образовательные и медицинские лицензии Дома Русской Косметологии')
    SiteMetaTags.create!(identifier: '/faqs', title: 'Вопросы к Институту косметологии', og_title: 'Вопросы к Институту косметологии',
                         description: 'В этом разделе Вы можете посмотреть ответы на самые частые вопросы к институту косметологии.',
                         og_description: 'В этом разделе Вы можете посмотреть ответы на самые частые вопросы к институту косметологии.')
    SiteMetaTags.create!(identifier: '/mass_media', title: 'СМИ об Институте косметологии', og_title: 'СМИ об Институте косметологии',
                         description: 'В данном разделе сайта собрана информация о косметологов, парикмахеров, визажистов, массажистов и событиях Дома Русской Косметологии.',
                         og_description: 'В данном разделе сайта собрана информация о косметологов, парикмахеров, визажистов, массажистов и событиях Дома Русской Косметологии.')
    SiteMetaTags.create!(identifier: '/business', title: 'Тренинговые услуги для руководителей и сотрудников салонов красоты, клиник, спа-центров.', og_title: 'Тренинговые услуги для руководителей и сотрудников салонов красоты, клиник, спа-центров.',
                         description: 'Дом Русской Косметологии предлагает комплексные услуги по созданию предприятий индустрии красоты (салонов, клиник, СПА-центров)',
                         og_description: 'Дом Русской Косметологии предлагает комплексные услуги по созданию предприятий индустрии красоты (салонов, клиник, СПА-центров)')
    SiteMetaTags.create!(identifier: '/articles', title: 'Статьи', og_title: 'Статьи',
                         description: ' В данном разделе сайта собраны советы косметологов, парикмахеров, визажистов, массажистов, и будут полезны всем кто интересуется миром моды и красоты.',
                         og_description: ' В данном разделе сайта собраны советы косметологов, парикмахеров, визажистов, массажистов, и будут полезны всем кто интересуется миром моды и красоты.')
    SiteMetaTags.create!(identifier: '/models', title: 'Дом Русской Косметологии предлагает бесплатные процедуры', og_title: 'Дом Русской Косметологии предлагает бесплатные процедуры',
                         description: 'Дом Русской Косметики приглашает волонтеров на бесплатные процедуры по косметологии, перманентный макияж, химические пилинги.',
                         og_description: 'Дом Русской Косметики приглашает волонтеров на бесплатные процедуры по косметологии, перманентный макияж, химические пилинги.')
    SiteMetaTags.create!(identifier: '/errors', title: 'Такой страницы не существует', og_title: 'Такой страницы не существует')
    SiteMetaTags.create!(identifier: '/specialities', title: 'Курсы косметологов | Программы обучения в Доме Русской Косметологии', og_title: 'Курсы косметологов | Программы обучения в Доме Русской Косметологии',
                         description: 'Курсы маникюра, педикюра, наращивания ногтей, макияжа, массажа, косметологов и парикмахеров- отличная возможность овладеть профессией',
                         og_description: 'Курсы маникюра, педикюра, наращивания ногтей, макияжа, массажа, косметологов и парикмахеров- отличная возможность овладеть профессией')
    SiteMetaTags.create!(identifier: '/recalls', title: 'Отзывы выпускников о Доме Русской Косметологии', og_title: 'Отзывы выпускников о Доме Русской Косметологии',
                         description: 'На данной странице вы можете ознакомиться с отзывами о работе учебного центра академии "Дом Русской Косметологии".',
                         og_description: 'На данной странице вы можете ознакомиться с отзывами о работе учебного центра академии "Дом Русской Косметологии".')
  end

  def down
    drop_table :meta_tags
  end
end