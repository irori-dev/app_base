class CatForm::Component < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(cat: Cat.new)
    @cat = cat
  end

  private

  def submit_text
    @cat.new_record? ? '作成' : '更新'
  end

  def header_text
    @cat.new_record? ? 'ねこを作成' : 'ねこを更新'
  end
end
