require 'vcard'

class FeedItem < ActiveRecord::Base

  belongs_to :account

  validates_presence_of :account_id

  validates_presence_of :name
  validates_presence_of :date
  validates_uniqueness_of :date, :scope => [:name]

  validates_presence_of :raw_card

  before_validation :set_name_and_date

  scope :recent, { :conditions => "DAYOFYEAR(date) < DAYOFYEAR(NOW()) ", :limit => 20, :order => "DAYOFYEAR(date) DESC" }

  def card
    @card ||= Vpim::Vcard.decode(self.raw_card.force_encoding('ASCII-8BIT')).first
  end

  def title
    "#{name} - #{age} Years"
  end

  def summary
    "#{name} - #{age} Years - <a href='mailto:#{card['email']}'>#{card['email']}</a>".html_safe
  end

  def age
    Time.now.year - date.year
  end

  def created_at
    Time.parse("#{Time.now.year}-#{date.month}-#{date.day} 12:00")
  end

  private
  def set_name_and_date
    if card['bday']
      self.date = Time.parse(card['bday'])
      self.name = card['fn']
    end
  end
end
