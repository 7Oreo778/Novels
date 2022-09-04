class Public::UsersController < ApplicationController
  def index
   @users = User.all
   @user = current_user
   @novel = Novel.new
  end

  def show
    @user = User.find(params[:id])
    @novels = @user.novels.page(params[:page])
    @novel = Novel.new
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
     render "edit"
    else
     redirect_to public_user_path(current_user .id)
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(public_user_params)
      flash[:hoge] = "You have updated user successfully."
      redirect_to public_user_path(@user.id)
    else
      render :edit
    end
  end

  private

  def public_user_params
   params.require(:user).permit(:name, :profile_image, :introduction)
  end
end