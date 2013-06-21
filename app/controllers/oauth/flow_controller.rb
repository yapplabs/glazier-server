require 'services/github'

class Oauth::FlowController < ApplicationController
  def callback
    html = <<-HTML
      <script>
      var queryString;
      if (document.location.hash) {
        queryString = document.location.hash.substring(1);
      } else {
        queryString = document.location.search.substring(1);
      }
      window.opener.postMessage(queryString, window.location.origin);
      window.close();
      </script>
    HTML
    render text: html, content_type: 'text/html'
  end
end
