require 'xmlrpc/client'

module Seopult
  class Client

    def login
      client.call('Seopult.Auth.getSession', username: config.username, password: Digest::MD5.hexdigest(config.password), authmethod: 'md5')
    end

    def projects
      safe_call('Seopult.Project.getList')
    end

    def projects_stats(date = Date.current)
      safe_call('Seopult.Project.getProjectsMoneyStats', date: date.to_s)
    end

    def keywords(project_id)
      safe_call('Seopult.Keyword.getList', project: project_id)
    end

    def keyword_links(keyword_id)
      safe_call('Seopult.Link.getList', keyword: keyword_id)
    end

    def project_links(project_id)
      safe_call('Seopult.Link.getListByProject', project: project_id)
    end

    private

    def safe_call(method, params = {})
      login
      if params.blank?
        client.call(method)
      else
        client.call(method, params)
      end
    end

    def client
      @client ||= ::XMLRPC::Client.new(config.api_endpoint, '/')
    end

    def config
      OpenStruct.new(Rails.application.secrets.seopult)
    end
  end
end