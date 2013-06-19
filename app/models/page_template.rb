class PageTemplate < ActiveRecord::Base
  class NotFoundError < Error; end

  attr_accessible :key, :value

  def self.current(prefix)
    if Rails.env.test?
      "<html><head></head><body>Test #{prefix}</body></html>"
    else
      record = self.find_by_key("#{prefix}:current")
      if record.nil?
        raise NotFoundError.new("\"#{prefix}\" template not found. You may need to run `grunt ingest`.")
      end
      record.value
    end
  end
end
