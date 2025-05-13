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

  def change_degree(degree_id)
    cookie[:degree] = {
      value: degree_id,
      domain: :all
    }
  end

  def degree
    return unless cookie[:degree]

    Degree.find(cookie[:degree])
  end

  private

  attr_reader :cookie

  def save!
    cookie[:approved_approvable_ids] = {
      value: approved_approvable_ids.to_json,
      domain: :all
    }
  end
end
