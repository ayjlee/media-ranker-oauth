class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_user
  before_action :require_login, except: [:root]

  def render_404
    # DPR: supposedly this will actually render a 404 page in production
    raise ActionController::RoutingError.new('Not Found')
  end

  private

    def find_user
      if session[:user_id]
        @login_user = User.find_by(id: session[:user_id])
      end
    end

    def logged_in?
      !@login_user.nil?
    end

    def require_login
      unless logged_in?
        flash[:status] = :failure
        flash[:result_text] = "You must log in to do that"

        redirect_to root_path
      end
    end
end
