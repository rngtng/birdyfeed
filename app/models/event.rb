class Event < ActiveRecord::Base
  has_event_calendar \
    :use_all_day => true, 
    :use_javascript => false,
    :link_to_day_action => true

  belongs_to :account

  validates_presence_of :account_id
  validates_presence_of :start_at

  scope :recent, { :conditions => "start_at <= NOW() ", :limit => 30, :order => "start_at DESC" }

  def raw_card=(card_string)
    write_attribute(:raw_card, card_string)
    if card['bday']
      self.start_at = Time.parse("#{Time.now.year}-#{birthday_at.month}-#{birthday_at.day} 12:00")
      self.name = "#{card['fn']} - #{age} Years"
      self.all_day = true
    end
  end

  def summary
    "#{name} - #{age} Years - <a href='mailto:#{card['email']}'>#{card['email']}</a>".html_safe
  end

  def age
    Time.now.year - self.birthday_at.year
  end

  def birthday_at
    @birthday_at ||= Time.parse("#{card['bday']} 12:00")
  end

  def created_at
    start_at
  end

  private
  def card
    @card ||= Vpim::Vcard.decode(self.raw_card.force_encoding('ASCII-8BIT')).first
  end

end
