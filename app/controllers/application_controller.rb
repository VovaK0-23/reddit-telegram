class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale

  private

  def set_locale
    if user_signed_in? && params[:locale].present? && current_user.locale != params[:locale]
      current_user.update(locale: params[:locale])
    end

    session[:locale] = current_user.try(:locale) || params[:locale] || I18n.default_locale
    I18n.locale = session[:locale]
  end
end
