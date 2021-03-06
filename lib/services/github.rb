require "faraday"
require "uri"

# Uses a cache-friendly HTTP client to be as nice as possible to Github's API
module Services
  module Github
    class InvalidCredentials < StandardError; end

    class << self
      def exchange(code)
        verify_auth_code(code)
        github_response = faraday_client("https://github.com").post(
          "/login/oauth/access_token",
          {
            "client_id" => Glazier::ApiCredentials::GITHUB_CLIENT_ID,
            "client_secret" => Glazier::ApiCredentials::GITHUB_CLIENT_SECRET,
            "code" => code
          }
        )

        if github_response.status != 200
          false
        else
          github_response.body =~ /access_token=([0-9a-f]+)/
          $1
        end
      end

      def get_user(access_token)
        get '/user', access_token
      end

      def get_public_repos_with_push_permission(access_token)
        repos = get('/user/repos', access_token, type: 'public')
        orgs = get('/user/orgs', access_token)
        orgs.each do |org|
          login = org.fetch('login')
          org_repos = get("/orgs/#{login}/repos", access_token, type: 'public')
          repos.concat(org_repos)
        end
        repos.select {|repo| repo['permissions'] && repo['permissions']['push'] }.map {|repo| repo['full_name']}
      end

      def get(url, access_token, params=nil)
        retry_count = 5

        raise InvalidCredentials if access_token.blank?

        begin
          res = faraday_client.get do |req|
            req.url url
            req.headers['Authorization'] = "token #{access_token}"
            req.params.merge!(params) if params
          end

          if res.status == 401
            raise InvalidCredentials, "Invalid credentials"
          end

          ActiveSupport::JSON.decode(res.body)

          # handle intermittent blank JSON responses
        rescue MultiJson::LoadError
          retry_count -= 1
          if retry_count >= 0
            Rails.logger.debug("MultiJson::LoadError from #{url}, retrying")
            retry
          else
            Rails.logger.debug("MultiJson::LoadError from #{url}, giving up...")
          end
        end
      end

      def is_valid_repository?(repository)
        return false if repository.blank?
        owner, repo = repository.split('/', 2)
        return false unless /[a-z0-9-]+/i =~ owner

        res = faraday_client.head do |req|
          req.url "/repos/#{owner}/#{URI.encode_www_form_component(repo)}"
          req.params['client_id'] = Glazier::ApiCredentials::GITHUB_CLIENT_ID
          req.params['client_secret'] = Glazier::ApiCredentials::GITHUB_CLIENT_SECRET
        end
        res.status == 200
      end

      def verify_auth_code(code)
        unless code =~ /^[a-z0-9]+$/i
          raise "invalid code #{code}"
        end
      end

      private
      def faraday_client(base_url = "https://api.github.com")
        Faraday.new(:url => base_url) do |builder|
          builder.use :http_cache, Rails.cache
          builder.request :url_encoded
          builder.adapter Faraday.default_adapter
          builder.response :logger if Rails.env.development?
          builder.headers[:user_agent] = "glazier-server v#{GlazierServer::VERSION}"
        end
      end
    end
  end
end
