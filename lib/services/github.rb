require "faraday"
require "uri"

# Uses a cache-friendly HTTP client to be as nice as possible to Github's API
module Services
  module Github
    def self.exchange(code)
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

    def self.get_user_data(access_token)
      url = "/user?access_token=#{access_token}"
      github_response = faraday_client.get(url)

      if github_response.status == 401
        raise "Bad credentials"
      end

      JSON.parse(github_response.body)
    end


    def self.is_valid_repository?(repository)
      params = URI.encode_www_form(
        "client_id" => Glazier::ApiCredentials::GITHUB_CLIENT_ID,
        "client_secret" => Glazier::ApiCredentials::GITHUB_CLIENT_SECRET
      )
      github_response = faraday_client.head("/repos/#{repository}?#{params}")
      github_response.status == 200
    end

    private

    def self.verify_auth_code(code)
      unless code =~ /^[a-z0-9]+$/i
        raise "invalid code #{code}"
      end
    end

    def self.faraday_client(base_url = "https://api.github.com")
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
