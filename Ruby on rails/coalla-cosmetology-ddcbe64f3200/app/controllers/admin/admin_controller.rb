# Базовый контроллер для административной панели
module Admin
  class AdminController < ApplicationController
    include StoreRequestPath

    PER_PAGE = 50
    LIST_SIZE = 15

    before_action :update_current_shop_id
    before_action :authenticate_user!

    class << self
      def set_current_shop_for_model(model, options = {})
        before_action options do
          if current_shop
            SharedModels.set_current_shop_for_model(model, current_shop.id)
            @shop_dependent_controller = true
          end
        end
      end
    end

    helper_method :shop_dependent_controller?

    def shop_dependent_controller?
      @shop_dependent_controller
    end

    protected

    def apply_commit_action
      send(commit_action)
    end

    def commit_action
      @commit_action ||= params['commit'].presence || params['extras'].try(:[], 'commit').presence || 'save'
    end

    def upload_error(ex)
      if ex.is_a?(Errno::ENAMETOOLONG)
        'Слишком длинное имя файла.'
      else
        ex.message
      end
    end

    def prepare_ransack_params(params)
      return {} unless params
      result = params.to_unsafe_h
      result.each do |key, value|
        next if %w(true false).exclude?(value)
        result[key] = [value]
      end
      result
    end
  end
end