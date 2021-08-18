# Поиск банка по БИК
# @see app/views/admin/subscription_contracts/show.haml
# @see app/views/admin/practice_bases/_form.haml
# @see app/views/admin/subscription_contracts/show.haml
module Admin
  class BanksController < AdminController
    before_action do
      authorize! :search, :banks
    end

    def search
      bank = ActiveSupport::JSON.decode(HTTParty.get("http://www.bik-info.ru/api.html?type=json&bik=#{params[:bic]}").body)
      render json: { bank: bank }
    rescue => ex
      Rails.logger.error("Couldn't find bank. #{ex.message}")
      render nothing: true
    end
  end
end