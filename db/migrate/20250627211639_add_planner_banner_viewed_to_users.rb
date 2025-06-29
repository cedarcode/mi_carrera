class AddPlannerBannerViewedToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :planner_banner_viewed, :boolean, default: false
  end
end
