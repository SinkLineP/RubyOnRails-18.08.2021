json.groups @groups do |group|
  json.id group.id
  json.title group.title
end

json.educationForms @education_forms do |education_form|
  json.id education_form.id
  json.title education_form.title
end

json.groupPrices @group_prices do |group_price|
  json.id group_price.id
  json.title group_price.amo_display_text
end

json.promotions @promotions do |promotion|
  json.id promotion.id
  json.title promotion.display_name
end

json.discounts @discounts do |discount|
  json.id discount.id
  json.title discount.title
end

if @group_subscription.present?
  json.documents [@group_subscription.subscription_contract,
                  @group_subscription.payer_agreement,
                  @group_subscription.practice_agreement].reject(&:blank?) do |document|
    json.id document.id
    json.userFile document.user_file.try(:url)
    json.title I18n.t("documents.#{document.class.name.underscore}")
  end
end

json.educationLevels @education_levels do |level|
  json.id level.id
  json.title level.title
end

json.amoModules @amo_modules do |amo_module|
  json.id amo_module.id
  json.title amo_module.title
end

if @module_subscriptions.present?
  json.moduleSubscriptions @module_subscriptions do |module_subscription|
    json.id module_subscription.id
    json.title module_subscription.course.short_name
    json.amocrmId module_subscription.amocrm_id
  end
end