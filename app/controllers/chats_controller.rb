class ChatsController < InheritedResources::Base
  include Devise::Controllers::Helpers

  def index
    @chat = current_user.chats
  end

  def show; end

  def create
    @chat = Chat.create(chat_params)

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

  def edit
    @chat = Chat.find(params[:id])
  end

  def update
    @chat = Chat.find(params[:id])
    if @chat.update(chat_params)
      flash[:notice] = 'Chat was updated!'
      redirect_to chats_path
    else
      flash[:alert] = 'Please fill all fields correctly!'
      render :edit
    end
  end

  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy
    flash.notice="Chat '#{@chat.name}' was deleted"
    redirect_to chats_path
  end

  private

  def chat_params
    params.require(:chat).permit(:name, :user_id, :subreddit, :subreddit_sorting)
  end
end
