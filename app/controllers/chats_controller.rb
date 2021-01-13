class ChatsController < InheritedResources::Base
  include Devise::Controllers::Helpers

  def show
    # @user = User.find(params[:id])
    # @chat = Chat.where(user_id: @user.id)
    @chat = current_user.chats
  end

  def create
    @chat = Chat.create(app_chat_params)

    if @chat.persisted?
      flash[:notice] = 'Chat was saved'
      redirect_to chats_path(current_user.id)
    else
      flash.now[:alert] = 'Please fill all fields correctly'
      render :new
    end
  end

  def new
    @chat = Chat.new
  end

  def destroy
    # if @chat.destroy.destroyed?
    #   flash[:notice] = 'Item was deleted'
    # else
    #   flash[:alert] = "Item wasn't deleted"
    # end
  end

  private

  def chat_params
    params.require(:post).permit(:name, :user_id)
  end

  def app_chat_params
    params.require(:chat).permit(:name, :user_id)
  end

end
