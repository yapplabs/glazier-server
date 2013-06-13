require 'manifest_ingester'

class CardManifest < ActiveRecord::Base
  self.primary_key = :name

  attr_accessible :manifest, :name

  def self.ingest(url)
    manifest = ManifestIngester.urlToJson(url)
    name = manifest['name']
    self.find_or_create_by_name(name, url: url, manifest: manifest)
  end

  def self.reingestAll
    self.all.find_in_batches(batch_size: 25) do |group|
      group.each do |card_manifest|
        self.ingest(card_manifest.url)
      end
    end
  end
end
