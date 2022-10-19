class CatForm::Component < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(cat: Cat.new)
    @cat = cat
  end
end
