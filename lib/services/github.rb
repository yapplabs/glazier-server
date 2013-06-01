require "net/https"
require "uri"

module Services
  module Github
    def self.exchange(code)
      verify_auth_code(code)

      uri = URI.parse("https://github.com/login/oauth/access_token")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      github_response = http.request_post(uri.path, URI.encode_www_form({
        "client_id" => Glazier::ApiCredentials::GITHUB_CLIENT_ID,
        "client_secret" => Glazier::ApiCredentials::GITHUB_CLIENT_SECRET,
        "code" => code
      }))

      if github_response.code != "200"
        false
      else
        github_response.body =~ /access_token=([0-9a-f]+)/
        $1
      end
    end

    def self.get_user_data(access_token)
      uri = URI.parse("https://api.github.com/user?access_token=#{access_token}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      github_response = http.request_get(uri.path + '?' + uri.query)

      if github_response.code == "401"
        raise "Bad credentials"
      end

      JSON.parse(github_response.body)
    end

    def self.verify_auth_code(code)
      unless code =~ /^[a-z0-9]+$/i
        raise "invalid code #{code}"
      end
    end
  end
end
