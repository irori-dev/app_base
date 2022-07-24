class TopAlert::Component < ViewComponent::Base
  def initialize(type: 'success', message: '', dismissible: false)
    @type = type
    @message = message
  end
end