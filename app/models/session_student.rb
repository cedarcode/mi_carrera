class SessionStudent < BaseStudent
  def initialize(session)
    super(session[:approved_approvable_ids] || [])
    @session = session
  end

  def welcome_banner_viewed?
    session[:welcome_banner_viewed]
  end

  def welcome_banner_mark_as_viewed!
    session[:welcome_banner_viewed] = true
  end

  private

  attr_reader :session

  def save!
    session[:approved_approvable_ids] = approved_approvable_ids
  end
end
