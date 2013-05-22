class AppsController < ApplicationController
  def index
    html = PageTemplate.current("index")
    add_meta_tag(html, 'github_client_id', Glazier::ApiCredentials::GITHUB_CLIENT_ID)
    render text: html, content_type: 'text/html'
  end

  private

  def add_meta_tag(html, name, value)
    html.insert(head_pos(html), "<meta name='#{name}' content='#{value}'>")
  end

  def head_pos(html)
    head_open = html.index("<head")
    html.index(">", head_open) + 1
  end
end
