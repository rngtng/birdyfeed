class FeedsController < ApplicationController

  layout false

  def show
    @account = Account.find_by_id(params[:account_id])

    @title = "Birthdays"

    @feed_items = @account.feed_items.recent
    @updated = @feed_items.first.created_at
  end

end
