require 'digest/md5'

namespace :glazier do
  desc "ingest an html file"
  task :ingest, [:file_path] => :environment do |t, args|
    file_path = args[:file_path]

    if file_path.blank?
      puts "Usage: rake glaizer:ingest[path/to/html/file]"
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

    puts "To set this as the current index, use:"
    puts "  bundle exec rake glazier:set_current[#{fingerprint}]"
  end

  desc "set a given html entry as current"
  task :set_current, [:fingerprint] => :environment do |t, args|
    key = "index:#{args[:fingerprint]}"
    target = PageTemplate.find_by_key(key)
    current = PageTemplate.find_or_create_by_key("index:current")
    current.value = target.value
    current.save!
    puts "Success!"
  end
end