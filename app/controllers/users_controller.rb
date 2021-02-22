class UsersController < ApplicationController

  def locale
    user = User.find(params[:id])
    if user.locale.present?
      if user.locale == 'en'
        user.update(locale: 'ru')
      else
        user.update(locale: 'en')
      end
    else
      user.update(locale: 'ru')
    end

    redirect_back(fallback_location: root_path)
  end
end
