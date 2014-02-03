class RenameFranchiseToGuaranteeOfSatisfactionInSettings < ActiveRecord::Migration
  def self.up
    rename_column :settings, :franchise, :guarantee_of_satisfaction
  end

  def self.down
    rename_column :settings, :guarantee_of_satisfaction, :franchise
  end
end
