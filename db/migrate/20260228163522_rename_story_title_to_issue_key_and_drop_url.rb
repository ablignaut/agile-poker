class RenameStoryTitleToIssueKeyAndDropUrl < ActiveRecord::Migration[8.1]
  def change
    rename_column :stories, :title, :issue_key
    remove_column :stories, :url, :string
  end
end
