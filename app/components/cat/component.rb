class Cat::Component < ViewComponent::Base
  include Turbo::FramesHelper

  with_collection_parameter :cat

  def initialize(cat: Cat.new)
    @cat = cat
  end
end
