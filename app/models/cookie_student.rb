class CookieStudent < BaseStudent
  def initialize(cookie)
    @cookie = cookie
    super(cookie_to_hash(cookie[:approved_approvable_ids]))
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
    cookie[:approved_approvable_ids] = hash_to_cookie(approved_approvable_ids)
  end

  def cookie_to_hash(cookie)
    cookie.is_a?(String) ? cookie.split('&').map(&:to_i) : []
  end

  def hash_to_cookie(hash)
    hash.map(&:to_s).join('&')
  end
end
