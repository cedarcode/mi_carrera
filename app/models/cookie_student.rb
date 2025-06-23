class CookieStudent < BaseStudent
  def initialize(cookie)
    @cookie = cookie.permanent
    super(JSON.parse(@cookie[:approved_approvable_ids] || "[]"))
  end

  def welcome_banner_viewed?
    cookie[:welcome_banner_viewed] == "true"
  end

  def welcome_banner_mark_as_viewed!
    cookie[:welcome_banner_viewed] = {
      value: "true",
      domain: :all
    }
  end

  def degree
    update_degree
    Degree.find_by(id: cookie[:degree_id])
  end

  private

  attr_reader :cookie

  def save!
    cookie[:approved_approvable_ids] = {
      value: approved_approvable_ids.to_json,
      domain: :all
    }
  end

  def update_degree
    return if cookie[:degree_id].present?

    cookie[:degree_id] = {
      value: Degree.default.id,
      domain: :all
    }
  end
end
