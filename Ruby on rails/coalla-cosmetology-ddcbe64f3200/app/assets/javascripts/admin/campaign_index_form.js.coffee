#=require ./base_form
CampaignIndexForm = Views.BaseForm.extend
  el: '#campaign_index_form'

  events:
    'ajax:success': 'afterSave'

  initialize: ->
    $('.js-form').customForm();
    initDatepicker();

new CampaignIndexForm()