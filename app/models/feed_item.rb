require 'vpim/vcard'

class FeedItem < ActiveRecord::Base

  belongs_to :account

  validates_presence_of :account_id
  validates_presence_of :raw_card
  validates_presence_of :name
  validates_presence_of :date

  validates_uniqueness_of :date, :scope => [:name]

  before_save :set_name_and_date

  def card
    Vpim::Vcard.decode(self.raw_card).first
  end

  private
  def set_name_and_date
    self.date = Time.parse(card['bday'])
    self.name = card['fn']}
  end
end
