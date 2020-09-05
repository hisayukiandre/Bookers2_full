class BooksController < ApplicationController
  before_action :authenticate_user! # ログインしていない場合の遷移を無効

  def index
  	@books = Book.all
  	@book = Book.new
  end


  def create
  	@book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have creatad book successfully."
    else
      @books = Book.all
      flash[:notice] = 'error'
      render :index
    end
  end

  def show
  	@book = Book.find(params[:id])
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user_id.to_i != current_user.id #他のユーザのユーザ編集ページにurlからアクセスできないように
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id), notice: "You have updated book successfully."
    else
      @books = Book.all
      flash[:notice] = 'error'
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
  def book_params
  	params.require(:book).permit(:title, :body, :user_id)
  end
end
