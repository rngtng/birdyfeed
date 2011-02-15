class FeedsController < ApplicationController

  def show
    @account = Account.find_by_id(params[:account_id])
    @title = "Birthdays"

    @feed_items = @account.feed_items.recent
    @updated = @feed_items.first.created_at

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

end
