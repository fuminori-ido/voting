class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_user, :v_i18n

  private

  def current_user
    @_current_user ||=
        if Rails.env.test?
          if (user = User.not_deleted.find_by_code(ENV['VOTING_TEST_USER_CODE']))
            user
          else
            user = User.create!(code: SecureRandom.hex)
            start_new_session_for(user)
            user
          end
        else
          if (sssn = authenticated?)
            sssn.user
          else
            user = User.create!(code: SecureRandom.hex)
            start_new_session_for(user)
            user
          end
        end
  end

  def v_i18n(word, **options)
    I18n.t(word, **options.merge(scope: :text))
  end

  def redirect_to_index_with_success
    redirect_to url_for(action: 'index'), notice: v_i18n('successfully_saved')
  end
end
