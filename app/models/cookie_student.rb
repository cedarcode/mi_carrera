class CookieStudent < BaseStudent
  def initialize(cookie)
    @cookie = cookie.permanent
    super(JSON.parse(@cookie[:approved_approvable_ids] || "[]"))
  end

  def banner_viewed?(banner_type)
    if banner_type == 'welcome'
      cookie[:welcome_banner_viewed] == "true"
    else
      raise "Invalid banner type: #{banner_type}"
    end
  end

  def mark_banner_as_viewed!(banner_type)
    if banner_type == 'welcome'
      cookie[:welcome_banner_viewed] = {
        value: "true",
        domain: :all
      }
    else
      raise "Invalid banner type: #{banner_type}"
    end
  end

  def degree
    Degree.default
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
