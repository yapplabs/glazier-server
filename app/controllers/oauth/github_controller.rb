class Oauth::GithubController < ApplicationController
  def callback
    html = <<-HTML
      <script>
      window.opener.postMessage('#{safe_auth_code}', "*");
      window.close();
      </script>
    HTML
    render text: html, content_type: 'text/html'
  end

  def exchange
    require "net/https"
    require "uri"

    uri = URI.parse("https://github.com/login/oauth/access_token")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    github_response = http.request_post(uri.path, URI.encode_www_form({
      "client_id" => Glazier::ApiCredentials::GITHUB_CLIENT_ID,
      "client_secret" => Glazier::ApiCredentials::GITHUB_CLIENT_SECRET,
      "code" => safe_auth_code
    }))
    if github_response.code != "200"
      render text: "Github API call failed. Be sure that your GitHub API credentials are set properly.",
             content_type: 'text/plain', status: 500
    else
      github_response.body =~ /access_token=([0-9a-f]+)/
      render text: "#{$1}", content_type: 'text/plain'
      # 'Access-Control-Allow-Origin' => '*'
    end
  end

private

  def safe_auth_code
    auth_code = params[:code]
    unless auth_code =~ /^[a-z0-9]+$/i
      raise "invalid code #{auth_code}"
    end
    auth_code
  end
end
