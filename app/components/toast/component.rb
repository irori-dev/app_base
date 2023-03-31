class Toast::Component < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(message:, type: :notice)
    @type = type
    @message = message
  end

  def icon
    case @type
    when :alert
      'svgs/x_mark'
    when :warning
      'svgs/exclamation_triangle'
    else
      'svgs/check'
    end
  end

  def icon_wrapper_classes
    universal_classes = %w[
      inline-flex
      items-center
      justify-center
      flex-shrink-0
      w-8
      h-8
      rounded-lg
    ]
    particular_classes = case @type
                         when :notice
                           %w[text-green-500 bg-green-100]
                         when :alert
                           %w[text-red-500 bg-red-100]
                         when :warning
                           %w[text-orange-500 bg-orange-100]
                         else
                           %w[text-gray-500 bg-gray-100]
                         end

    universal_classes + particular_classes
  end
end
