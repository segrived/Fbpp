class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
 
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  before_filter :disable_sidebar!, only: [:render_403, :render_404]
  before_filter :set_locale

  def set_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      cookies['locale'] = { :value => params[:locale], :expires => 1.year.from_now }
      I18n.locale = params[:locale].to_sym
      redirect_to :back
    elsif cookies['locale'] && I18n.available_locales.include?(cookies['locale'].to_sym)
      I18n.locale = cookies['locale'].to_sym
    end
  end

  def enable_sidebar!
    @has_sidebar = true
  end

  def disable_sidebar!
    @has_sidebar = false
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500 }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404 }
  end

  protected

  def render_403
    render_error 403
  end

  def render_404
    render_error 404
  end

  def render_error(status)
    respond_to do |format|
      format.html { render "errors/#{status}", status: status }
      format.all { render nothing: true, status: status }
    end
  end

  private

  # Необходимо не иметь аккаунта администратора
  def shouldnt_have_admin_account
      render_403 if exists_admin_account?
  end

  # Необходимо быть неавторизированным
  def require_not_auth
    render_403 if logged?
  end

  # Необходима авторизация
  def require_auth
    render_403 unless logged?
  end

  # Необходимо наличие прав администратора
  def require_admin_rights
    render_403 unless can_admin?
  end

  def require_admin_account
    render_403 unless logged_user.admin?
  end
end