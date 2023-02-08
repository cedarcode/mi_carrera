class AddWelcomeBannerViewedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :welcome_banner_viewed, :boolean, default: false
  end
end
