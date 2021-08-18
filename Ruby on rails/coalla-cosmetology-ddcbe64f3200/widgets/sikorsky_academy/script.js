define([
  "jquery",
  window.location.origin + "/upl/sikorsky_academy_extensions/widget/api.js",
  window.location.origin + "/upl/sikorsky_academy_extensions/widget/controls.js"
], function($, API, Controls) {
  var CustomWidget = function() {
    var self = this,
      api = new API(this),
      controls = new Controls(this);

    this.callbacks = {
      render: function() {
        if (self.system().area == "lcard") {
          self.renderAdditionalInfo();
        }

        if (self.system().area == "ccard") {
          self.loadAndRenderEducationLevels();
        }

        return true;
      },
      init: function() {
        return true;
      },
      bind_actions: function() {
        return true;
      },
      settings: function() {
        return true;
      },
      onSave: function() {
        return true;
      },
      destroy: function() {},
      contacts: {
        selected: function() {}
      },
      leads: {
        selected: function() {}
      },
      tasks: {
        selected: function() {}
      }
    };

    this.loadAndRenderEducationLevels = function() {
      var contactId = AMOCRM.constant("card_id"),
        params = Number(contactId) > 0 ? { amocrm_id: contactId } : {};

      api.query("student_info/list", params, function(response) {
        renderEducationLevels(response.educationLevels);

        if (response.editUrl) {
          var editLink =
            '<div class="linked-form__field">' +
            '<div class="linked-form__field__label">' +
            "<span>Карточка студента</span>" +
            "</div>" +
            "<div>" +
            '<a href="' +
            response.editUrl +
            '" target="_blank">' +
            response.editUrl +
            "</a>" +
            "</div>" +
            "</div>";

          $("#edit_card")
            .find(".linked-form__field:last")
            .after(editLink);
        }

        if (response.documents && response.documents.length > 0) {
          var html =
            '<div class="linked-form__field">' +
            '<div class="linked-form__field__label">' +
            "<span>Копии документов</span>" +
            "</div>" +
            "</div>";

          $("#edit_card")
            .find(".linked-form__field:last")
            .after(html);

          _.map(response.documents, function(document) {
            controls.fileLink(document);
          });
        }
      });
    };

    this.renderAdditionalInfo = function() {
      self.$groupIdInput = $('input[name*="CFV[1760641]"]');
      self.$educationFormIdInput = $('input[name*="CFV[1760643]"]');
      self.$discountIdInput = $('input[name*="CFV[1760647]"]');
      self.$promotionIdInput = $('input[name*="CFV[1795998]"]');
      self.$groupPriceIdInput = $('input[name*="CFV[1760645]"]');
      self.$amoModuleInput = $('input[name*="CFV[1781856]"]');
      self.$priceRawInput = $(".js-control-raw-price");
      self.$priceInput = $("#lead_card_budget");
      self.$leadNameInput = $("#person_name");

      self.$priceInput.attr("readonly", "readonly");

      _.each(
        [
          self.$groupIdInput,
          self.$educationFormIdInput,
          self.$groupPriceIdInput,
          self.$discountIdInput,
          self.$promotionIdInput,
          self.$amoModuleInput
        ],
        function($item) {
          $item.closest(".linked-form__field").hide();
        }
      );

      self.$groupIdInput.change(function() {
        self.$leadNameInput.val(
          $("#groups_list")
            .closest(".linked-form__field")
            .find(".control--select--list--item-selected > span")
            .text()
        );
        self.$leadNameInput.trigger("input");
        self.$priceInput.val("0");
        self.$priceRawInput.val("0");
        self.$groupPriceIdInput.val("");
        loadAndRenderGroupPrices();
      });

      self.$educationFormIdInput.change(function() {
        self.$priceInput.val("0");
        self.$priceRawInput.val("0");
        self.$groupPriceIdInput.val("");
        loadAndRenderGroupPrices();
      });

      _.each([self.$groupPriceIdInput, self.$discountIdInput], function($item) {
        $item.change(function() {
          calculatePrice();
        });
      });

      var leadId = AMOCRM.constant("card_id"),
        params = Number(leadId) > 0 ? { amocrm_id: leadId } : {};

      params["education_form_id"] = self.$educationFormIdInput.val();
      params["group_id"] = self.$groupIdInput.val();

      api.query("group_subscription_info/list", params, function(response) {
        renderGroups(response.groups);
        renderEducationForms(response.educationForms);
        renderGroupPrices(response.groupPrices);
        renderDiscounts(response.discounts);
        renderPromotions(response.promotions);
        renderDocuments(response.documents);
        renderModuleSubscriptions(response.moduleSubscriptions);
        renderEducationLevels(response.educationLevels);
        renderAmoModules(response.amoModules);
      });

      $(document).bind("ajaxSuccess", function(e, data) {
        if (!data.responseJSON || data.responseJSON.id != leadId) {
          return true;
        }

        var $leadClosingDateInput = $('input[name*="CFV[1777152]"]'),
          dateStr = $leadClosingDateInput.val();

        if (dateStr.length == 0) {
          return true;
        }

        var dateParts = dateStr.split(".").reverse(),
          stamp = Math.floor(
            Date.UTC(+dateParts[0], +dateParts[1], +dateParts[2]) / 1000
          ),
          req = {
            request: {
              leads: {
                update: [
                  { id: leadId, date_close: stamp, last_modified: +Date.now() }
                ]
              }
            }
          };
        $.post("/private/api/v2/json/leads/set", req);

        return true;
      });
    };

    function renderGroups(groups) {
      var items = controls.selectOptionsFromJson(groups);
      controls.select(self.$groupIdInput, {
        id: "groups_list",
        items: items,
        label: "Группа"
      });
    }

    function renderEducationForms(educationForms) {
      var items = controls.selectOptionsFromJson(educationForms);
      controls.select(self.$educationFormIdInput, {
        id: "education_forms_list",
        items: items,
        label: "Формы обучения"
      });
    }

    function renderGroupPrices(groupPrices) {
      var items = controls.selectOptionsFromJson(groupPrices);
      controls.select(self.$groupPriceIdInput, {
        id: "group_prices_list",
        items: items,
        label: "Вид оплаты"
      });
    }

    function renderDiscounts(discounts) {
      var items = controls.selectOptionsFromJson(discounts);
      controls.select(self.$discountIdInput, {
        id: "discounts_list",
        items: items,
        label: "Скидки"
      });
    }

    function renderPromotions(promotions) {
      var items = controls.selectOptionsFromJson(promotions);
      controls.select(self.$promotionIdInput, {
        id: "promotions_list",
        items: items,
        label: "Акция - продажа"
      });
    }

    function renderAmoModules(amoModules) {
      var items = amoModules ? controls.selectOptionsFromJson(amoModules) : [];
      controls.select(self.$amoModuleInput, {
        id: "amo_modules_list",
        items: items,
        label: "Модули"
      });
    }

    function renderDocuments(documents) {
      var html =
          '<div class="linked-form__field">' +
          '<div class="linked-form__field__label">' +
          "<span>Докумены</span>" +
          "</div>" +
          "</div>",
        $html = $(html);

      self.$discountIdInput.closest(".linked-form__field").after($html);

      _.map(documents, function(document) {
        controls.documentLink($html, document);
      });
    }

    function renderModuleSubscriptions(moduleSubscriptions) {
      if (!moduleSubscriptions || moduleSubscriptions.length === 0) {
        return;
      }

      var html =
          '<div class="linked-form__field">' +
          '<div class="linked-form__field__label">' +
          "<span>Сделки модуля</span>" +
          "</div>" +
          "</div>",
        $html = $(html);

      self.$discountIdInput.closest(".linked-form__field").after($html);

      _.map(moduleSubscriptions, function(subscription) {
        controls.leadLink($html, subscription);
      });
    }

    function renderEducationLevels(educationLevels) {
      var $educationLevelInput = $('input[name*="CFV[1760649]"]'),
        items = controls.selectOptionsFromJson(educationLevels);

      $educationLevelInput.closest(".linked-form__field").hide();

      controls.select($educationLevelInput, {
        id: "education_levels_list",
        items: items,
        label: "Уровень образования"
      });
    }

    function loadAndRenderGroupPrices() {
      api.query(
        "group_prices/list",
        {
          education_form_id: self.$educationFormIdInput.val(),
          group_id: self.$groupIdInput.val()
        },
        function(response) {
          renderGroupPrices(response);
        }
      );
    }

    function calculatePrice() {
      var discountId = self.$discountIdInput.val(),
        groupPriceId = self.$groupPriceIdInput.val();

      if (groupPriceId.length == 0) {
        return;
      }

      api.query(
        "price_calculator/calculate",
        {
          discount_id: discountId,
          group_price_id: groupPriceId
        },
        function(response) {
          self.$priceInput.val(response.price);
          self.$priceRawInput.val(response.price);
          self.$priceInput.trigger("input");
          self.$priceRawInput.trigger("input");
          self.$priceInput.focusout();
        }
      );
    }

    return this;
  };

  return CustomWidget;
});
