class ChatsController < InheritedResources::Base

  private

  def chat_params
    params.require(:post).permit(:name, :user_id)
  end

end
