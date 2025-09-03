class AddReadToEmails < ActiveRecord::Migration[8.0]
  def change
    add_column :emails, :read, :boolean, default: false, null: false
  end
end
