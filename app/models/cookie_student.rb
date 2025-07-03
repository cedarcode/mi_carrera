class CookieStudent < BaseStudent
  VALID_BANNER_TYPES = %w[welcome].freeze

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
    Degree.default
  end

  def total_credits
    @total_credits ||= 0
  end

  def total_credits=(value)
    @total_credits = value.to_i
  end

  def group_credits
    @group_credits ||= {}
  end

  def group_credits=(value)
    @group_credits = value
  end

  private

  attr_reader :cookie

  def save!
    cookie[:approved_approvable_ids] = {
      value: approved_approvable_ids.to_json,
      domain: :all
    }
    cookie[:total_credits] = {
      value: total_credits,
      domain: :all
    }
    cookie[:group_credits] = {
      value: group_credits.to_json,
      domain: :all
    }
  end
end
