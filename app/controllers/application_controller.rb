class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale

  private

  def set_locale
    if user_signed_in? && params[:locale].present? && current_user.locale != params[:locale]
      current_user.update(locale: params[:locale])
    end

    I18n.locale = current_user.try(:locale) || I18n.default_locale
  end
end
