class Picture < ActiveRecord::Base
  MAX_SIZE = 100.kilobytes

  attr_accessible :data

  belongs_to :contact

  # before_validation :check_size
  # validates :data, :presence => true, :length => { :within => 1..MAX_SIZE }

  before_save :check_size

  # TODO save image to file, and/or resize

  def check_size
    if self.data.size > MAX_SIZE
      puts "Image too large #{data.size}"
      File.open("#{self.contact.uid}.jpg", 'w:ASCII-8BIT') { |f| f.print data }
      self.data = self.data[0...MAX_SIZE]
    end
  end
end
