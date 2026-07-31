module ControllerRequestHelper
  # Returns the request object the controller saw, for attributes like remote_ip that
  # only exist once the middleware stack has run.
  def request_seen_by_controller
    seen = nil
    subscriber = ActiveSupport::Notifications.subscribe('start_processing.action_controller') do |*, payload|
      seen = payload[:request]
    end

    yield

    seen
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber)
  end
end
