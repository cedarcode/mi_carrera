class SessionStudent < BaseStudent
  def initialize(session)
    super(session[:approved_approvable_ids] || [])
    @session = session
  end

  private

  attr_reader :session

  def save!
    session[:approved_approvable_ids] = approved_approvable_ids
  end
end
