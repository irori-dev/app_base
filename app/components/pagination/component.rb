class Pagenation::Component < ViewComponent::Base
  def initialize; end

  # def initialize(kaminarized_data: )
  #   @current_page = kaminarized_data.current_page
  #   @total_pages = kaminarized_data.total_pages
  #   @total_count = kaminarized_data.total_count
  #   @per_page = kaminarized_data.per_page
  #   @display_pages = display_pages
  # end

  private

  def display_pages
    if @total_pages <= 5
      (1..@total_pages).to_a
    else
      if @current_page <= 5
        (1..10).to_a
      elsif @current_page >= @total_pages - 5
        (@total_pages - 9..@total_pages).to_a
      else
        (@current_page - 5..@current_page + 5).to_a
      end
    end
  end
end