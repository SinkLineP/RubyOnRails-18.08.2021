# Поиск в административной панели
module Admin
  class SearchController < AdminController
    before_action :set_current_shop

    def search
      @searches = ThinkingSphinx.search s_find_escape,
                                        order: 'created_at desc',
                                        page: params[:page],
                                        per_page: 10,
                                        with: { shop_id: [current_shop.id, 0] }
    end

    protected

    def after_shop_update_path
      url_for(controller: :search, action: :search)
    end

    private

    def s_find_escape
      Riddle::Query.escape(params[:search].to_s)
    end
  end
end