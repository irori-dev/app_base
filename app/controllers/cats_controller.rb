class CatsController < ApplicationController
  before_action :set_cat, only: %i[edit update destroy]

  def index
    @search = Cat.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?

    @cats = @search.result.page(params[:page])
  end

  def new
    @cat = Cat.new
  end

  def edit; end

  def create
    @cat = Cat.new(cat_params)
    @cat.save!
    flash.now.notice = 'ねこを登録しました。'
  rescue StandardError
    render :new, status: :unprocessable_entity
  end

  def update
    @cat.update!(cat_params)
    flash.now.notice = 'ねこを更新しました。'
  rescue StandardError
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @cat.destroy
    flash.now.notice = 'ねこを削除しました。'
  end

  private

  def set_cat
    @cat = Cat.find(params[:id])
  end

  def cat_params
    params.require(:cat).permit(:name, :age)
  end
end
