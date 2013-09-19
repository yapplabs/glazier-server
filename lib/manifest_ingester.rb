require "net/http"
require "uri"
require "zlib"

# provides manifest ingestation
module ManifestIngester
  extend self
  IngestionFailedError = Class.new(StandardError)

  def from_url(url)
    uri = URI.parse(url)

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request Net::HTTP::Get.new(uri.request_uri)
    end

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
