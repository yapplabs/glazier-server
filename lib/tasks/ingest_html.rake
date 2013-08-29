require 'digest/md5'

namespace :glazier do
  desc "ingest an html file"
  task :ingest, [:file_path] => :environment do |t, args|
    file_path = args[:file_path]

    if file_path.blank?
      puts "Usage: rake glazier:ingest[path/to/html/file]"
      exit
    end

    html = File.read(file_path)
    fingerprint = Digest::MD5.hexdigest(html)
    key = "index:#{fingerprint}"
    page_template = PageTemplate.find_by_key(key)

    if page_template.present?
      puts "This file is identical to one that has already been ingested\n\n"
    else
      PageTemplate.create!(key: key, value: html)
    end

    puts "To set this as the current index, in the glazier-server project, use:"
    puts "  heroku surrogate rake 'glazier:set_current[#{fingerprint}]'"

    ENV['GLAZIER_INGEST_FINGERPRINT'] = fingerprint
  end

  desc "set a given html entry as current"
  task :set_current, [:fingerprint] => :environment do |t, args|
    fingerprint = args[:fingerprint] || ENV['GLAZIER_INGEST_FINGERPRINT']
    key = "index:#{fingerprint}"
    target = PageTemplate.find_by_key!(key)
    current = PageTemplate.find_or_create_by_key("index:current")
    current.value = target.value
    current.save!
    puts "Success!"
  end

  desc "ingest and set current"
  task :ingest_as_current, [:file_path] => [:ingest, :set_current]

  namespace :card do
    task :ingest, [:file_paths] => :environment do |t, args|
      file_paths = args[:file_paths]

      if file_paths.blank?
        puts "Usage: rake glazier:card:ingest[path/to/card/manifest.json]"
        exit
      end

      file_paths = file_paths.split('|')

      file_paths.each do |file_path|
        manifest = ActiveSupport::JSON.decode(File.read(file_path))
        name = manifest.fetch('name')
        url = manifest.fetch('url')
        PaneType.create_or_update_by_name(name, url: url, manifest: MultiJson.dump(manifest))
      end
    end
  end
end
