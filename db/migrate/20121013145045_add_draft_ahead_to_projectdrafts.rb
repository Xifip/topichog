class AddDraftAheadToProjectdrafts < ActiveRecord::Migration
  def change
   add_column :projectdrafts, :draft_ahead, :boolean
  end
end
