require 'manifest_ingester'

class PaneType < ActiveRecord::Base
  self.primary_key = :name

  has_many :panes, dependent: :delete_all, foreign_key: :pane_type_name
  # pane_type_user_entries.where(:github_id => current_user.github_id)
  has_many :pane_type_user_entries, foreign_key: :pane_type_name, dependent: :delete_all

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
    pane_type = where(name: name).first

    if pane_type
      pane_type.update_attributes(args)
    else
      pane_type = create!(args.merge(name: name))
    end

    pane_type
  end

  def self.reingest_all
    self.all.each do |pane_type|
      begin
        self.ingest(pane_type.url)
      rescue ManifestIngester::IngestionFailedError
        puts "unable to reingest from #{pane_type.url}"
      end
    end
  end
end
