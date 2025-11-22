module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?, :available_for?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def authenticated?
    resume_session
  end

  # Is current user available for the controller (and action)?
  #
  # @return [bool]
  def available_for?(_controller_name, _action = nil)
    case _controller_name
    when 'votes'
      true
    when 'candidates'
      current_user.admin? || !_action.nil? && (_action == 'thumb' ||
                                               _action == 'big_thumb')
    else
      current_user.admin?
    end
  end

  def require_authentication
    return if available_for?(params[:controller], params[:action])

    request_authentication
  end

  def resume_session
    Current.session ||= find_session_by_cookie
  end

  def find_session_by_cookie
    Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
  end

  # redirect to login page to request authentication
  def request_authentication
    session[:return_to_after_authenticating] = request.url
    redirect_to new_session_path
  end

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || root_url
  end

  def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      Current.session = session
      cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
    end
  end

  def terminate_session
    Current.session.destroy
    cookies.delete(:session_id)
  end
end
