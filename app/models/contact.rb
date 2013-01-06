class Contact < ActiveRecord::Base

  serialize :social, DataSerializer
  store_accessor :social, :skype, :twitter, :icq, :jabber, :msn, :facebook, :soundcloud

  serialize :additional_data, DataSerializer

  has_one :original_vcard, :autosave => true, :dependent => :destroy
  has_many :pictures, :autosave => true, :dependent => :destroy
  belongs_to :contact_account

  validates :uid, :presence => true, :uniqueness => true

  def import(card_string)
    card = Vcard::Vcard.decode(card_string.force_encoding('ASCII-8BIT')).first

    self.first_name = card.name.given
    self.last_name  = card.name.family
    self.nick_name  = card.nickname
    self.company    = Array(card.org).first

    self.birthday   = card.birthday.to_s

    self.tags       = Array(card.categories).join(",").gsub('\\', '')
    self.notes      = card.note

    get_socials(card).tap do |raw_socials|
      self.skype      = raw_socials[:skype]
      # self.twitter    = raw_socials[:twitter]
      self.icq        = card['X-ICQ']
      self.jabber     = card['X-JABBER']
      self.msn        = card['X-MSN']
      self.facebook   = raw_socials[:facebook]
      # self.soundcloud  = raw_socials[:soundcloud]
    end

    card.telephones.each_with_index do |telephone, index|
      key = telephone.location.sort.join("_").downcase
      if value = Phonie::Phone.parse(telephone.to_s)
        if !self.tel_1 && value.is_mobile?
          self.tel_1 = value.to_s
        elsif !self.tel_2
          self.tel_2 = value.to_s
        else
          self.additional_data[:tel] ||= {}
          self.additional_data[:tel][key] = value.to_s
        end
      else
        next if key.empty?
        self.additional_data[:tel_malcious] ||= {}
        self.additional_data[:tel_malcious][key] = telephone.to_s
      end
    end

    card.emails.each_with_index do |email, index|
      key   = email.location.sort.join("_").downcase
      value = email.to_s
      if !self.email
        self.email = value
      else
        self.additional_data[:email] ||= {}
        self.additional_data[:email][key] = value
      end
    end

    card.urls.each_with_index do |url, key|
      value = url.uri.delete('\\')
      if !self.url
        self.url = value  # TODO decode
      else
        self.additional_data[:url] ||= {}
        self.additional_data[:url][key.to_s] = value
      end
    end

    card.addresses.each_with_index do |address, key|
      if !self.street && !self.plz && !self.city && !self.country
        self.street  = address.street
        self.plz     = address.postalcode
        self.city    = address.locality
        self.country = address.country
      else
        self.additional_data[:addresses] ||= {}
        self.additional_data[:addresses][key.to_s] = {
          :street  => address.street,
          :plz     => address.postalcode,
          :city    => address.locality,
          :country => address.country,
        }
      end
    end

    card.photos.each do |photo|
      self.pictures.build(:data => photo)
    end
  end

  def vcard=(content)
    self.build_original_vcard(:data => content)
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
