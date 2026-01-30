class CookieStudent < BaseStudent
  VALID_BANNER_TYPES = %w[welcome].freeze

  attr_writer :degree

  def initialize(cookie)
    @cookie = cookie.permanent
    super(JSON.parse(@cookie[:approved_approvable_ids] || "[]"))
  end

  def banner_viewed?(banner_type)
    if VALID_BANNER_TYPES.include?(banner_type)
      cookie[:"#{banner_type}_banner_viewed"] == "true"
    else
      raise "Invalid banner type: #{banner_type}"
    end
  end

  def mark_banner_as_viewed!(banner_type)
    if VALID_BANNER_TYPES.include?(banner_type)
      cookie[:"#{banner_type}_banner_viewed"] = {
        value: "true",
        domain: :all
      }
    else
      raise "Invalid banner type: #{banner_type}"
    end
  end

  def degree
    Degree.find_by(id: degree_id) || Degree.default
  end

  def save
    cookie[:approved_approvable_ids] = {
      value: approved_approvable_ids.to_json,
      domain: :all
    }
    cookie[:degree_id] = {
      value: degree_id,
      domain: :all
    }
    true
  end

  def degree_id
    @degree&.id || cookie[:degree_id].presence || Degree.default.id
  end

  def save! = save

  private

  attr_reader :cookie
end
