class ChatsController < InheritedResources::Base
  include Devise::Controllers::Helpers

  def index
    @chat = current_user.chats
  end

  def create
    @chat = Chat.create(chat_params)

    if @chat.persisted?
      flash[:notice] = t('.success')
      redirect_to chats_path(current_user.id)
    else
      flash.now[:error] = t('.error')
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
      flash[:notice] = t('.success')
      redirect_to chats_path
    else
      flash[:error] = t('.error')
      render :edit
    end
  end

  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy
    flash.notice = t('.error', chat_name: @chat.name)
    redirect_to chats_path
  end

  private

  def chat_params
    params.require(:chat).permit(:name, :user_id, :subreddit, :subreddit_sorting, :limit, :time, :auto_posting)
  end
end
