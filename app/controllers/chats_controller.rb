class ChatsController < InheritedResources::Base
  include Devise::Controllers::Helpers

  def index
    @chat = current_user.chats
  end

  def show; end

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
    @chat = Chat.find(params[:id])
    @chat.destroy
    flash.notice="Chat '#{@chat.name}' was deleted"
    redirect_to chats_path
  end

  private

  def chat_params
    params.require(:post).permit(:name, :user_id)
  end

  def app_chat_params
    params.require(:chat).permit(:name, :user_id)
  end

end
