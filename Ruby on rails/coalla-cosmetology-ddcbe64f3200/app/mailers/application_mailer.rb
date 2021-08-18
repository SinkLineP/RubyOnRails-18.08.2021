class ApplicationMailer < ActionMailer::Base
  default from: (Rails.env.staging? ? '"Дом Русской Косметики" <no-reply@cosmetic.coalla.ru>' : '"Дом Русской Косметики" <info@cosmeticru.com>')

end
