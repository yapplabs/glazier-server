require "net/http"
require "uri"

# provides manifest ingestation
module ManifestIngester
  def self.urlToJson(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request_get(uri.path)

    return unless (200...300).include? response.code
    JSON.parse(github_response.body)
  end
end
