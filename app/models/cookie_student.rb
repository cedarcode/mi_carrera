class CookieStudent < BaseStudent
  def initialize(cookie)
    @cookie = cookie
    super(JSON.parse(cookie[:approved_approvable_ids] || "[]"))
  end

  def welcome_banner_viewed?
    cookie[:welcome_banner_viewed] == "true"
  end

  def welcome_banner_mark_as_viewed!
    cookie[:welcome_banner_viewed] = "true"
  end

  private

  attr_reader :cookie

  def save!
    cookie[:approved_approvable_ids] = approved_approvable_ids.to_json
  end
end
