require 'services/github'

class Oauth::GithubController < ApplicationController
  def callback
    code = params[:code]
    Services::Github.verify_auth_code(code)

    html = <<-HTML
      <script>
      window.opener.postMessage('#{code}', "*");
      window.close();
      </script>
    HTML
    render text: html, content_type: 'text/html'
  end

  def exchange
    access_code = Services::Github.exchange(params[:code])
    if !access_code
      render text: "Github API call failed. Be sure that your GitHub API credentials are set properly.",
             content_type: 'text/plain', status: 500
    else
      render text: "#{access_code}", content_type: 'text/plain'
      # 'Access-Control-Allow-Origin' => '*'
    end
  end
end
