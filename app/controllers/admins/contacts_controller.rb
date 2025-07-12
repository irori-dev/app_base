class Admins::ContactsController < Admins::BaseController

  include Searchable

  def index
    @contacts = setup_search(Contact).page(params[:page])
  end

end
