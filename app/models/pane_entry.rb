class PaneEntry < ActiveRecord::Base
  attr_accessible :pane_id, :key, :value
  belongs_to :pane
end
