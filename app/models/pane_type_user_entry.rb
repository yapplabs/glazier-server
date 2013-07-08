class PaneTypeUserEntry < ActiveRecord::Base
  attr_accessible :pane_type_name, :key, :value
  belongs_to :pane_type, foreign_key: :pane_type_name
  belongs_to :user, foreign_key: :github_id
end
