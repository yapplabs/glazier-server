require 'manifest_ingester'

class CardManifest < ActiveRecord::Base
  self.primary_key = :name

  attr_accessible :manifest, :name, :url

  def consumes!(service_name)
    hash = MultiJson.load(manifest)
    hash["consumes"]

    if hash["consumes"].include?(service_name)
      return puts "#{name} already consumes #{service_name}"
    end

    hash["consumes"].push(service_name)

    self.manifest = MultiJson.dump(hash)
    save!
  end

  def self.ingest(url)
    manifest = ManifestIngester.from_url(url)
    name = manifest.fetch('name')
    self.create_or_update_by_name(name, url: url, manifest: MultiJson.dump(manifest))
  end

  def self.create_or_update_by_name(name, args = {})
    card_manifest =  where(name: name).first

    if card_manifest
      card_manifest.update_attributes(args)
    else
      card_manifest = create!(args.merge(name: name))
    end

    card_manifest
  end

  def self.reingest_all
    self.all.each do |card_manifest|
      self.ingest(card_manifest.url)
    end
  end
end
