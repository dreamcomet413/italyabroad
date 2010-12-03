class Type < ActiveRecord::Base
  def show_errors
    return "- " + self.errors.full_messages.join("<br />- ")
  end
end
