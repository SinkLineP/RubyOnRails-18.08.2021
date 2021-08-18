# frozen_string_literal: true

Rails.application.routes.draw do
  # redirect for trailing slashes
  constraints(lambda { |r| r.original_fullpath.end_with?("/") }) do
    get "*path", to: redirect { |params, request| request.original_fullpath.chomp("/") }
  end

  # redirect for multiple slashes in url
  constraints(lambda { |r| r.original_fullpath.squeeze!("/") }) do
    get "*path", to: redirect { |params, request| request.original_fullpath }, status: :moved_permanently
  end

  resources :used_times, only: [] do
    get :list, on: :collection
  end

  resources :call_results, only: [:create, :index]

  resource :paykeepers, only: [] do
    post :result
    get :failed, on: :collection
    get :success, on: :collection
  end

  resource :subscription_notifications, only: [] do
    get :unsubscribe, on: :collection
  end

  namespace :amo do
    resources :contacts, only: :create do
      post :delete, on: :collection
    end
    resources :leads, only: :create do
      post :change_status, on: :collection
    end
    resources :notes, only: :create
  end

  namespace :api do
    resources :documents, only: [] do
      get :load, on: :member
    end
    resources :private_files, only: [] do
      get :load, on: :collection
    end
    # AMOcrm умеет отправлять только POST-запросы
    resources :group_prices, only: [] do
      post :list, on: :collection
    end
    resource :student_info, only: [], controller: :student_info do
      post :list, on: :collection
    end
    resource :group_subscription_info, only: [], controller: :group_subscription_info do
      post :list, on: :collection
    end
    resource :price_calculator, only: [], controller: :price_calculator do
      post :calculate
    end
  end

  constraints(Routes::CoursesShopConstraint) do
    scope module: :courses_shop, as: :courses_shop do
      devise_for :users, module: "courses_shop/users", only: %i(sessions passwords registrations omniauth_callbacks)

      unless Rails.env.development?
        %w( 404 422 500 ).each do |code|
          get code, to: "errors#show", code: code
        end
      end

      resource :barbers, only: :show
      resource :hairdresser, only: :show
      get "/new-base" => "new_bases#show"
      get "/new-base-promo1" => "new_bases#promo1"
      get "/new-base-promo2" => "new_bases#promo2"
      get "/new-base-promo3" => "new_bases#promo3"
      get "/new-base-promo4" => "new_bases#promo4"
      get "/new-base-promo5" => "new_bases#promo5"
      get "/new-base-promo6" => "new_bases#promo6"
      get "/new-base-promo7" => "new_bases#promo7"
      get "/new-base-promo8" => "new_bases#promo8"
      resources :promo_subscriptions, only: :create
      resources :callbacks, only: [] do
        post :send_form_data, on: :collection
      end

      resource :social, only: %i(destroy), module: :users

      constraints(lambda { |r| r.original_fullpath.gsub!(/kursy-management/, "kursy-salonam-i-klinikam") }) do
        get "*path", to: redirect { |params, request| request.original_fullpath }, status: :moved_permanently
      end

      scope path: "/*url", constraints: Routes::OldUrlsConstraint do
        resources :old_urls, only: :show, path: ""
      end

      scope controller: :business, path: :business do
        get :consulting
        get :partners
        get :regional_schools
        get :manufacturers_and_dealers
        get :mass_media
        get :corporate_education
        get :recruitment
      end

      get "/shop_info" => "shop_info#show", format: :xml
      get "/promotion_info" => "promotion_info#show", format: :xml

      get "/robots.txt" => "robots#robots", :format => "txt"

      scope controller: :about, path: :about do
        get :history
        get :partners, as: :about_partners
        get :diploma
        get :teachers
        get :tour
        get :graduates
        get :cecutient_version
      end

      scope controller: :home do
        get :contacts
        get :license
        get :offer
        get :privacy_policy
        get :models
        get :promotions
        get :cookies_policy
      end

      resource :privacy_policy, only: [] do
        post :confirm, on: :collection
      end

      resource :cart, only: [:show, :update]
      resources :promo_codes, only: [] do
        post :check, on: :collection
      end

      resource :profile, only: [:edit, :update] do
        resource :schedule, only: :show
        resource :courses, only: :show, controller: :user_courses do
          get :download_document
        end
        resources :documents, only: %i(index create destroy show)
      end
      resources :procedure_requests, only: :create
      resources :phones, only: :create
      resource :configurator, only: :show, controller: :configurator
      resource :search, only: :show, controller: :search
      resources :institution_blocks, only: :index, path: :info
      resources :courses, only: [] do
        resource :consultations, only: :create
      end
      resources :orders, only: %i(create new) do
        get :pay, on: :member
        get :pay_tkb, on: :member
        get :tkb_result, on: :member
      end
      resources :groups, only: :show
      resources :group_subscriptions, except: :index
      resources :faqs, only: %i(index)
      resources :user_questions, only: %i(create)
      resources :recalls, only: :index
      resources :blogs, :science_and_drks, only: %i(index show)
      resources :mass_media, only: %i(index show), as: :mass_media_section
      resources :unisender, only: [] do
        post :subscribe, on: :collection
        get :subscribe, on: :collection
      end

      resources :courses, only: :show, path: "/:speciality_id", constraints: Routes::CoursesConstraint
      resources :specialities, only: :show, path: "/(:root_id)", constraints: Routes::SpecialitiesConstraint

      scope controller: :markup, as: :markup, path: "markup" do
        get :demo
        get :index
        get :courses
        get :course
        get :course_added
        get :about
        get :info
        get :contacts
        get :promotions
        get :licenses
        get :faq
        get :feedbacks
        get :personal_cabinet_courses
        get :personal_cabinet_schedule
        get :personal_cabinet_documents
        get :personal_cabinet_settings
        get :basket
        get :articles
        get :article
        get :offer
        get :models
        get :mass_media
        get :for_business
        get :search_results
        get :configurator_results
        get :error
        get :disability
      end

      get "/" => "home#index", as: :root
    end
  end

  mount Ckeditor::Engine => "/ckeditor"
  devise_for :users, only: [:sessions, :omniauth_callbacks, :passwords], controllers: { sessions: "user/sessions", omniauth_callbacks: "user/omniauth_callbacks", passwords: "user/passwords" }
  scope :users do
    resources :authentications, only: :destroy, as: :user_authentications, controller: "user/authentications"
  end

  get "/surveymonkey/response_completed" => "surveymonkey#response_completed", format: "json"
  post "/surveymonkey/response_completed" => "surveymonkey#response_completed", format: "json"

  get "/robots.txt" => "robots#robots", :format => "txt"

  unless Rails.env.development?
    %w( 404 422 500 ).each do |code|
      get code, to: "errors#show", code: code
    end
  end

  scope constraints: Routes::AdminConstraint,
        module: :admin,
        as: :admin,
        subdomain: "admin",
        domain: Rails.application.secrets.shops_domains["barbershop"] do
    get "/banks/search" => "banks#search", as: :search_bank
    get "/users/search" => "users#search", as: :search_users
    resources :holidays, only: %i(index create destroy)
    resource :attendance_report, only: %i(new create)
    resource :attendance, only: :show, controller: :attendance
    resources :survey_responses, only: %i(index)
    resources :contacts_merges, only: %i(new create)
    resources :services, :graduates, :promotions, :promo_codes, :automatic_discounts, except: :show
    resources :history_events, except: :show do
      collection do
        get :sort
        post "/sort" => :apply_sort
      end
    end
    resources :institution_blocks, only: %i(index edit update)
    resources :business_pages, :about_pages, only: [:index, :edit, :update]
    resources :meta_tags, only: %i(index edit update)
    resources :services, except: :show
    resources :classrooms, except: :show
    resources :instructor_vacations, except: :show
    resources :ratings, only: %i(index create)
    resources :articles do
      post :toggle_field, on: :member
      post :notify, on: :member
      get :list, on: :collection
      get :blog_list, on: :collection
    end
    resources :offers, :privacy_policy, only: [:index, :edit, :update]
    resource :configurator, only: [:edit, :update], controller: :configurator
    resources :about_lookups, :social_lookups, only: [:index, :edit, :update]
    resources :our_advantages, only: [:index, :edit, :update]
    resources :specialities, only: [:index, :edit, :update] do
      get :list, on: :collection
    end
    resources :group_subscriptions, only: :index do
      get :list, on: :collection
    end
    resources :consultations, :tour_images, :reward_images, :amo_modules, except: :show
    resources :partners, except: :show
    resources :used_times, except: :show
    resources :faq, except: :show
    resources :curriculum_blocks, :advantages, :skills, :recalls, :faculties, except: :show do
      get :list, on: :collection
    end
    resources :generated_documents, only: [] do
      get :download, on: :member
      get :download_empty_sheet, on: :member
    end
    resources :group_subscriptions, only: [] do
      resource :contract, only: [:show, :update], controller: :subscription_contracts do
        post :send_contract, on: :member
      end
      resource :certificate, only: [:show, :update], controller: :subscription_certificates
      resource :attendance_report, only: [:new, :create], controller: :subscription_attendance_reports
    end
    resources :orders, only: [] do
      resource :contract, only: [:show, :update], controller: :order_contracts do
        post :send_contract, on: :member
      end
    end
    resource :amocrm_import, controller: :amocrm_import, only: [] do
      post :run
    end
    resources :course_works, only: :index
    resources :student_work_results, only: :create
    resources :work_results, except: :show
    resources :works, except: :show
    resources :vacancy_groups, except: :show
    resources :exercises, only: :create
    resources :practice_bases, except: :show
    resource :private_file, only: [:show, :create]
    resource :education_document_picture, only: :create
    resource :indices, only: :show
    resource :funnel, only: [:show, :create], controller: :funnel
    resource :charges_report, only: [:show, :create], controller: :charges_report
    resources :campaigns, only: :index
    resources :amocrm_statuses, only: :index
    resources :magazine_payment_types, except: :show
    resources :banners, :square_banners, except: :show
    resources :education_documents, only: [:index, :edit, :update] do
      get :list, on: :collection
    end
    resources :education_levels, except: :show
    resources :campaign_indices, except: :show
    resources :education_forms, only: :index
    resources :discounts, except: :show
    resource :en_page, only: [:edit, :update], controller: :en_page
    resource :pdf, only: :create, controller: :pdf
    resource :file, only: :create
    resources :letters, except: [:edit, :update] do
      get :reply, on: :member
    end
    resource :verification_tutorial, controller: :verification_tutorial, only: [:edit, :update]
    resource :tutorial, controller: :tutorial, only: [:edit, :update]
    resources :books do
      post :cover_create, on: :collection
    end
    resources :instructors, except: :show do
      get :list, on: :collection
      put :change_password, on: :member
    end
    resources :images, only: :create
    resources :post_categories, only: :index
    resources :posts, except: :show
    resources :courses do
      get :list, on: :collection
      post :funnel_generation, on: :collection
      resources :notices, only: [:new, :create], controller: :course_notices
      resource :content, controller: :course_content, only: [:edit, :update]
    end
    resources :groups do
      member do
        get :info
        post :clone
      end

      collection do
        get :search
      end

      resource :attendance_report, only: [:new, :create], controller: :group_attendance_reports
      resources :group_prices, only: :index
      resource :addition_order, only: [:show, :update], controller: :addition_orders
      resource :final_work_registry, only: [:show, :update], controller: :final_work_registries
      resource :attendance_log, only: [:show, :update], controller: :attendance_logs
      resource :group_list, only: [:show, :update], controller: :group_lists
      resource :expulsion_order, only: [:show, :update] do
        get :refunds
      end
    end
    resources :blocks do
      get :list, on: :collection
      post :clone, on: :member
    end
    resource :material_cover, only: :create
    resource :download, only: :create
    resource :question_image, only: :create
    resource :column_variant_images, only: :create
    resources :module_groups, only: [] do
      get :change, on: :collection
    end
    resources :students, except: :show do
      get :list, on: :collection
      post :import, on: :collection
      resources :group_subscriptions, except: :show do
        delete :really_destroy, on: :collection
      end
      resources :subscription_documents, only: [] do
        get :generate, on: :collection
      end
      resources :payments, only: [] do
        get :recalculate, on: :collection
      end
      resources :payment_logs, except: :show
      resources :orders, except: :show, controller: :orders
    end
    resources :administrators
    resources :managers
    resources :my_students, only: [:index, :show] do
      get :report, on: :member
      get :list, on: :collection
      resources :results, only: [:show, :update]
    end
    resources :results, only: [] do
      resource :comment, only: :update, controller: :result_comments do
        post :notify, on: :member
      end
    end
    resources :documents
    resources :static_pages, :document_sections, except: :show
    scope controller: :search do
      get :search
    end
    resources :contingents, only: %i(new create)
    resources :payments_reports, only: %i(new create)
    resources :payment_statistics, only: %i(new create)
    resources :debtor_reports, only: %i(new create)
    resources :period_orders, only: %i(new create)
    resource :modules_report, controller: :modules_report, only: %i(create)
    resources :uploaded_videos, except: :show do
      get :list, on: :collection
    end
    resources :logs, only: %i[index show]
    get "/" => "/home#index"
  end

  scope constraints: Routes::SdoConstraint,
        subdomain: "sdo",
        domain: Rails.application.secrets.shops_domains["barbershop"] do
    get "/ostatokmest" => "group_places#index"
    get "blog/(:filter)" => "posts#index", as: :blog
    get "blog/categories/:category_id/(:filter)" => "posts#index", as: :blog_category
    resource :blog, only: [] do
      resources :posts, only: :show
    end
    resources :blog_subscribers, only: :create

    resource :document_verification, only: [:show, :create]

    resources :courses, only: :show do
      get :preview, on: :collection
      get :rating, on: :member
      resources :lectures, only: :show
      resources :tasks, only: :show
      resources :results, only: :show
    end

    resources :lectures, only: [] do
      resources :materials, only: [:show] do
        post :mark_as_finished, on: :member
      end
    end

    resources :tasks, only: [] do
      resources :results, only: [:create] do
        post :expire, on: :collection
      end
      resources :files, only: :create, controller: :task_files
    end

    resource :progress, only: :show
    resources :vacancies, only: :index do
      get :show_content
    end

    resources :notices, only: :destroy

    get "feedback" => "feedback_questions#new", as: :feedback
    get "feedback/message_sent" => "feedback_questions#message_sent", as: :feedback_message_sent

    resources :feedback_questions, only: :create
    resources :feedback_question_files, only: :create

    get "en" => "english#index"

    resource :profile, only: %w(edit update)
    resource :private_file, only: %w(create)
    resources :books, only: %w(index show)
    resources :feedbacks, only: :create do
      get :message_sent, on: :collection
    end
    resource :tutorial, controller: :tutorial, only: :show do
      put :hide, on: :member
    end

    resources :user_activities, only: :create

    resources :static_pages, only: :show, path: "", constraints: { format: :html }

    get "/" => "home#index"
  end

  root to: redirect("/", subdomain: "sdo", domain: Rails.application.secrets.shops_domains["barbershop"])

  match "*unmatched_route", to: "default#page_not_found", via: :get, constraints: ->(req) { req.path.split(".").count <= 1 }
end
