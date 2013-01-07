class OriginalVcard < ActiveRecord::Base
  MAX_SIZE = 500.kilobytes

  attr_accessible :data

  belongs_to :contact

  # before_validation :check_size
  # validates :data, :presence => true, :length => { :within => 1..MAX_SIZE }

  before_save :check_size

  def check_size
    if self.data.size > MAX_SIZE
      puts "Card too large #{data.size}"
      File.open("#{self.contact.uid}.vcr", 'w:ASCII-8BIT') { |f| f.print data }
      self.data = self.data[0...MAX_SIZE]
    end
  end
end
