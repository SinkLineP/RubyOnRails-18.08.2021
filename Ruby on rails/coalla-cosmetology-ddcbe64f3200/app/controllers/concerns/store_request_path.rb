module StoreRequestPath
  include Admin::PathHistory
  extend ActiveSupport::Concern

  included do
    def store_path_history
      if request.method == 'GET' && session[:last_path] != request.fullpath && !new_edit?
        session[:prev_path] = session[:last_path]
        session[:last_path] = request.fullpath
      end
    end

    def new_edit?
      request.fullpath =~ /\/new|\/edit/i
    end
  end
end