module Amocrm
  class UnprocessableDataException < Exception; end
  class UnduplicatableSubscription < UnprocessableDataException; end

  DEFAULT_MANAGER = 406546

  CUSTOM_TAGS = %w(КЭ KO КЭВ KOV СК SK Э K КС KC КВ KV ММ MM СПА-М SPA-M)

  class ElementType
    CONTACT = 1
    LEAD = 2
  end
end

Amorail::Entity.include(Amocrm::EntityDecorator)
Amorail::Client.include(Amocrm::ClientDecorator)