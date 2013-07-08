class PaneUserEntry < ActiveRecord::Base
  attr_accessible :pane_id, :key, :value
  belongs_to :pane
  belongs_to :user, foreign_key: :github_id

  def self.add_or_update(attrs)
    card_entry = PaneUserEntry.where(attrs.slice(:pane_id, :github_id, :key)).first

    if card_entry
      card_entry.update_attribute :value, attrs[:value]
    else
      PaneUserEntry.create!(attrs.slice(:pane_id, :key, :value)) do |entry|
        entry.github_id = attrs[:github_id]
      end
    end
  end
end
