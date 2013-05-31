class CardEntry < ActiveRecord::Base
  ACCESS_TYPES = ["private", "public"]
  attr_accessible :access, :card_id, :key, :user_id, :value
  validates_inclusion_of :access, in: ACCESS_TYPES

  def self.valid_access_type?(access_type)
    ACCESS_TYPES.include? access_type
  end

  def self.add_or_update(attrs)
    card_entry = CardEntry.where(attrs.slice(:card_id, :user_id, :key, :access)).first

    if card_entry
      card_entry.update_attribute :value, attrs[:value]
    else
      CardEntry.create!(attrs.slice(:card_id, :user_id, :key, :value, :access))
    end
  end
end
