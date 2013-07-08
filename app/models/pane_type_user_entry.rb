class PaneTypeUserEntry < ActiveRecord::Base
  attr_accessible :pane_type_name, :key, :value
  belongs_to :pane_type, foreign_key: :pane_type_name
  belongs_to :user, foreign_key: :github_id

  def self.add_or_update(attrs)
    card_entry = self.where(attrs.slice(:pane_type_name, :github_id, :key)).first

    if card_entry
      card_entry.update_attribute :value, attrs[:value]
    else
      self.create!(attrs.slice(:pane_type_name, :key, :value)) do |entry|
        entry.github_id = attrs[:github_id]
      end
    end
  end
end
