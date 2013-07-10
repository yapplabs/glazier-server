class PaneUserEntry < ActiveRecord::Base
  belongs_to :pane
  belongs_to :user, foreign_key: :github_id
end
