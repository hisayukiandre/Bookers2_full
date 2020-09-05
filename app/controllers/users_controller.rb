class UsersController < ApplicationController
  before_action :authenticate_user! # ログインしていない場合の遷移を無効

  def index
  	@users = User.all
    @books = Book.all
    @book = Book.new
  end

   def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have creatad book successfully."
    else
      flash[:notice] = "error"
      render template: "books/index"
    end
  end

  def show
  	@user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def edit
    if user_signed_in?
  	  @user = User.find(params[:id])
    else
      redirect_to new_user_session_path
    end
    if @user.id != current_user.id #他のユーザのユーザ編集ページにurlからアクセスできないように
      redirect_to user_path(current_user.id)
    end
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update(user_params)
  	  redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      flash[:notice] = "error"
      render :edit
    end
  end


  private
  def user_params
  	params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
