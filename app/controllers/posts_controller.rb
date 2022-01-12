class PostsController < ApplicationController

  def new
    @post = Post.new
    @tag_lists = Tag.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # 受け取った値を,で区切って配列にする
    tag_list = params[:post][:names].split(',')
    if @post.save
       @post.save_tag(tag_list)
      redirect_to post_path(@post.id)
    else
      render :new
    end
  end

  def index
    @posts = Post.page(params[:page]).reverse_order.per(6)
    @tag_lists = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.all
    @post_tags = @post.tags
    @user = current_user
    @tag_lists = Tag.all
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
    @tag_lists = Tag.all
  end

  def update
    @post = Post.find(params[:id])
    tag_list=params[:post][:names].split(',')
    if @post.update(post_params)
       @post.save_tag(tag_list)
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  # ブックマーク一覧を表示する
  def bookmarks
    @bookmarks = Bookmark.where(user_id: current_user.id).all
    @user = current_user
  end

  # タグ検索画面
  def search_tag
    @tag = Tag.find(params[:tag_id])
    @tag_lists = Tag.all
    @posts = @tag.posts.all
  end

  # 検索機能
  def search
    @posts = Post.search(params[:keyword])
    @keyword = params[:keyword]
    @tag_lists = Tag.all
    render "index"
  end

  private

  def post_params
    params.require(:post).permit(:title, :image, :prefectures, :season, :word, :introduction)
  end

end
