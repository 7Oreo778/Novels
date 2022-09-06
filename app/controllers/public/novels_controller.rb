class Public::NovelsController < ApplicationController
  def new
    @novel = Novel.new
  end

  def create
    @novel = Novel.new(novel_params)
    @novel.user_id = current_user.id
    @user = current_user

    # save tags
    tag_list=params[:novel][:tag].split(',')

    if @novel.save
      @novel.save_tag(tag_list)
      flash[:hoge] = "Novel was successfully created."
      redirect_to public_novel_path(@novel.id)
    else
      @novels = Novel.all
      render :index
    end

  end

  def index
    @novels = Novel.page(params[:page]).per(10)
    @tag_list=Tag.all
    #@novel = Novel.new
    @user = current_user
  end

  def show
    @novel = Novel.find(params[:id])
    @user = @novel.user
    @novel_new = Novel.new

    @novel_comment = NovelComment.new
    #@novel_tags = @novel.tags
  end

  def edit
    @novel = Novel.find(params[:id])
  #@tag_list=@novel.tags.pluck(:name).join(',')

    if @novel.user == current_user
     render "edit"
    else
     redirect_to public_novels_path
    end
  end

  def update
    @novel = Novel.find(params[:id])
    @user = current_user
    tag_list=params[:post][:name].split(',')

    if @novel.update(novel_params)
      @novel.save_tag(tag_list)
      flash[:hoge] = "You have updated novel successfully."
      redirect_to public_novel_path(@novel.id)
    else
      render :edit
    end

  end


  def destroy
    @novel = Novel.find(params[:id])
    @novel.destroy
    redirect_to '/novels'
  end

  def search
    if params[:keyword].present?
      @novels = Novel.where('title LIKE ? or body LIKE ?', "%#{params[:keyword]}%", "%#{params[:keyword]}%")
      @keyword = params[:keyword]
    else
      @novels = Novel.all
    end
  end

  private

  def novel_params
    params.require(:novel).permit(:title, :body)
  end
end