require "net/http"
require "uri"
require "zlib"

# provides manifest ingestation
module ManifestIngester
  extend self
  IngestionFailedError = Class.new(StandardError)

  def from_url(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.request_get(uri.path)

    unless (200...300).include? response.code.to_i
      raise IngestionFailedError, {
        host: uri.host,
        port: uri.port,
        path: uri.path,
        response: response
      }.inspect
    end

    JSON.parse(inflate(response.body))
  end

private

  def inflate(buffer)
    Zlib::GzipReader.new(StringIO.new(buffer)).read
  rescue Zlib::GzipFile::Error
    buffer
  end
end
