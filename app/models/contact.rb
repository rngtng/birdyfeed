class Contact < ActiveRecord::Base
  # attr_accessible :title, :body

  validates :uid, :presence => true, :uniqueness => true

  store :social, :accessors => [:skype, :twitter, :icq, :jabber, :msn, :facebook, :soundcloud]
  #picture blob

  def import(card_string)
    card = Vcard::Vcard.decode(card_string.force_encoding('ASCII-8BIT')).first

    print self.first_name = card.name.given
    puts self.last_name   = card.name.family
    self.nick_name  = card.nickname
    self.company    = Array(card.org).first
    debugger

    self.birthday   = card.birthday.to_s

    self.notes      = card.note
    self.tags       = Array(card.categories).join ","

    socials         = get_socials(card)
    self.skype      = socials[:skype]
    # self.twitter    = socials[:skype]
    self.icq        = card['X-ICQ']
    self.jabber     = card['X-JABBER']
    self.msn        = card['X-MSN']
    self.facebook   = socials[:facebook]
    # self.soundcloud  = socials[:skype]


    telephones = card.telephones.inject({}) do |hash, telephone|
      key = telephone.location.sort.join("_").downcase
      if tel = Phonie::Phone.parse(telephone.to_s)
        key = "mobile" if tel.is_mobile?
        hash[key] = tel.to_s
      end
      hash
    end

    telephones.each do |key, value|
      if !self.tel_1 && %w(mobile cell iphone).include?(key)
        self.tel_1 = telephones.delete(key)
      end

      if !self.tel_2 && %w(home work).include?(key)
        self.tel_2 = telephones.delete(key)
      end
    end

    if telephones.size > 0
      puts "#{telephones.size} more telephones found: #{telephones.inspect}"
      # debugger
    end

    card.emails.clone.tap do |emails|
      if email = emails.shift
        self.email = email
      end
      puts "#{emails.size} more emails found" if emails.size > 0
    end
    # TODO where to put other emails

    card.urls.clone.map(&:uri).tap do |urls|
      if url = urls.shift
        self.url = url  # TODO decode
      end
      puts "#{urls.size} more urls found" if urls.size > 0
    end

    if address = card.addresses.shift
      self.street     = address.street  # TODO where to put other address
      self.plz        = address.postalcode
      self.city       = address.locality
      self.country    = address.country
    end

    card.photos.clone.tap do |photos|
      if photo = photos.shift
        self.picture = photo
      end
      puts "#{photos.size} more photos found" if photos.size > 0
    end
  end


  private
  def get_socials(card)
    card.groups.inject({}) do |hash, group|
      pair = card.fields.select { |l| l.group == group }.inject({}) do |lhash, field|
        key = (field.name.upcase == 'X-ABLABEL') ? :key : :value
        lhash[key] ||= field.value.downcase
        lhash
      end
      if key = pair[:key]
        hash[key.to_sym] = pair[:value]
      end
      hash
    end
  end

  # def consume(key, data, fields)
  # end
end
