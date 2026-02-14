class CookieStudent < BaseStudent
  VALID_BANNER_TYPES = %w[welcome].freeze

  attr_accessor :degree

  def initialize(cookie)
    @cookie = cookie.permanent
    super(JSON.parse(@cookie[:approved_approvable_ids] || "[]"))

    @degree = Degree.find_by(id: cookie[:degree_id]) if cookie[:degree_id].present?
    @degree ||= Degree.default
    @degree_plan = @degree.active_degree_plan
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

  def save
    cookie[:approved_approvable_ids] = {
      value: approved_approvable_ids.to_json,
      domain: :all
    }
    cookie[:degree_id] = {
      value: degree_id,
      domain: :all
    }
    cookie[:degree_plan_id] = {
      value: degree_plan_id,
      domain: :all
    }
    true
  end

  def save! = save

  delegate :id, to: :degree, prefix: true
  delegate :id, to: :degree_plan, prefix: true

  private

  attr_reader :cookie, :degree_plan
end
