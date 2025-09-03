class Email < ApplicationRecord
  after_update_commit -> { broadcast_replace_to :emails }
end
