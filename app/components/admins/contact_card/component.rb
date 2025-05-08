class Admins::ContactCard::Component < ViewComponent::Base

  with_collection_parameter :contact

  def initialize(contact:)
    @contact = contact
  end

  private

  def id
    @contact.id
  end

  def name
    @contact.name
  end

  def email
    @contact.email
  end

  def phone_number
    @contact.phone_number
  end

  def text
    @contact.text
  end

  def created_at
    @contact.created_at.strftime('%Y/%m/%d %H:%M:%S')
  end

end
