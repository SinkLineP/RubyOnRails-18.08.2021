class MailChimpService
  LIST_ID = 'd385ffea7e'
  TEMPLATE_ID = 51425

  def initialize(article, context)
    @article = article
    @context = context
  end

  def notify!
    gibbon = Gibbon::Request.new(api_key: Rails.application.secrets.mailchimp_api_key)

    body = {
        type: 'regular',
        recipients: {
            list_id: LIST_ID
        },
        settings: {
            subject_line: @article.title,
            title: "Campaign \"#{@article.title}\"",
            from_name: 'Дом Русской Косметики',
            reply_to: 'info@cosmeticru.com'
        }
    }

    begin
      campaign = gibbon.campaigns.create(body: body)
    rescue Gibbon::MailChimpError => e
      Rails.logger.error("Mailchimp campaign create error: #{e.message} - #{e.raw_body}")
    end

    template = {
        id: TEMPLATE_ID,
        sections: {
            std_content00: "<img src='#{URI.join(@context.root_url, @article.preview_image_url(:main))}' style='max-width:600px; height: auto; vertical-align: top; display: block; margin: 0 auto' id='campaign-new-icon'>
                            <a href='#{@context.current_article_url(@article)}/??utm_source=newsletter&utm_medium=email&utm_campaign=utm_promo' style='text-align: center; display:block; margin-top: 20px; font-size: 23px; line-height: 23px; color: #336699; font-weight: normal; text-decoration: underline;'>#{@article.title}</a>
                            <p style='text-align: center; margin-top: 20px; color: #505050; font-family: Arial; font-size: 14px; line-height: 150%;'>#{@article.announce}</p>"
        }
    }

    campaign_id = campaign.body['id']
    gibbon.campaigns(campaign_id).content.upsert(body: {template: template})
    gibbon.campaigns(campaign_id).actions.send.create
  end
end