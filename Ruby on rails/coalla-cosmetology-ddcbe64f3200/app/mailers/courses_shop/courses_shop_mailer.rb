module CoursesShop
  class CoursesShopMailer < ActionMailer::Base
    include LookupHelper
    add_template_helper(MailHelper)
    add_template_helper(GroupsHelper)
    add_template_helper(CartsHelper)
    add_template_helper(ApplicationHelper)
    add_template_helper(TypographHelper)

    layout 'mail'

    FROM = Rails.env.staging? ? '"Дом Русской Косметики" <no-reply@cosmetic.coalla.ru>' : '"Дом Русской Косметики" <info@cosmeticru.com>'
    BCC_EMAIL = (Rails.env.staging? ? 'dev@coalla.ru' : 'cosmeticru@mail.amocrm.ru')
    ADMIN_EMAIL = Rails.env.staging? ? 'at@coalla.ru' : 'info@cosmeticru.com'

    PROCEDURES_EMAIL = Rails.env.staging? ? 'at@coalla.ru' : %w(models@cosmeticru.com support@cosmeticruhelp.zendesk.com)

    default from: FROM,
            bcc: BCC_EMAIL

    DEV_EMAIL = 'dev@coalla.ru'

    def sign_in(user)
      @user = user
      mail(to: user.email, subject: "#{user.name_for_subject}Дом Русской Косметики. Регистрация", bcc: [])
    end

    def restore_password(user, shop)
      @user = user
      @shop = shop
      @custom_sign = '<div><i>- Команда Школы Светланы Сикорской</i></div>' if @shop.barbershop?
      subject = [user.name_for_subject, "#{@shop.barbershop? ? 'Школа Светланы Сикорской' : 'Дом Русской Косметики'}. Восстановление пароля"].join
      mail(to: user.email, subject: subject, bcc: [])
    end

    def procedure_request_to_user(procedure_request)
      @procedure_request = procedure_request
      mail(to: procedure_request.email, subject: 'ДРК. Запись на процедуры')
    end

    def procedure_request_to_admin(procedure_request)
      @procedure_request = procedure_request
      mail(to: PROCEDURES_EMAIL, subject: 'ДРК. Запись на процедуры')
    end

    def user_subscribed_on_blog(user)
      @user = user
      mail(to: @user.email, subject: "#{@user.text_for_subject('подписка на блог')}")
    end

    def new_password(user, password)
      @user = user
      @password = password
      mail(to: @user.email, subject: "#{@user.text_for_subject('новый пароль на сайте ДРК')}")
    end

    def promo_code(user,promo_code)
      @promo_code = promo_code
      mail(to: user.email, subject: "#{user.text_for_subject('ваш промокод для получения скидки')}", bcc: [])
    end

    def payment_message(order)
      @order = order
      @user = @order.user
      mail(to: ADMIN_EMAIL, subject: 'Оплата обучения')
    end

    def notify_unisender_subscriber(user, promo_code, password)
      @promo_code = promo_code
      @password = password
      @user = user
      nick = @user.email.split('@').first
      mail(to: @user.email, subject: 'Спасибо за регистрацию, будущий косметолог. Вот ваша скидка 3%')
    end

    def add_phone_discount(user, promo_code)
      @user = user
      @promo_code = promo_code
      mail(to: @user.email, subject: 'Скидка за указание телефона')
    end
  end
end