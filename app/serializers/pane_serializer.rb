class PaneSerializer < ActiveModel::Serializer
  attributes :id, :position, :pane_entries, :pane_user_entries, :pane_type_user_entries, :dashboard_id, :repository

  has_one :pane_type, embed: :ids, include: true, key: :pane_type_id, root: :pane_types

  def pane_entries
    entries_to_hash object.pane_entries
  end

  def pane_user_entries
    return {} unless current_user
    entries_to_hash object.pane_user_entries.where(github_id: current_user.github_id)
  end

  def pane_type_user_entries
    return {} unless current_user
    entries_to_hash object.pane_type_user_entries.where(github_id: current_user.github_id)
  end

  private
  def entries_to_hash(entries)
    entries.inject({})  do |hash, entry|
      hash[entry.key] = ActiveSupport::JSON.decode(entry.value)
      hash
    end
  end
end
