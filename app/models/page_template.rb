class PageTemplate < ActiveRecord::Base
  attr_accessible :key, :value

  def self.current(prefix)
    if Rails.env.test?
      "<html><head></head><body>Test #{prefix}</body></html>"
    else
      self.find_by_key("#{prefix}:current").value
    end
  end
end
