class Admins::ContactsController < Admins::BaseController
  def index
    @search = Contact.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?

    @contacts = @search.result.page(params[:page])
  end
end
