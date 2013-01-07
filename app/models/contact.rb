require 'date'

class Contact < ActiveRecord::Base
  FACEBOOK_URL = /facebook.com\/((profile.php\?id=(\d+))|(.+))/

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

    if birthday = card.birthday
      self.birthday = birthday.to_s
    end

    if categories = card.categories
      self.tags     = Array(categories).join(",").gsub('\\', '')
    end

    self.notes      = card.note

    get_socials(card).tap do |raw_socials|
      self.skype      = raw_socials[:skype]
      # self.twitter    = raw_socials[:twitter]
      self.icq        = card['X-ICQ']
      self.jabber     = card['X-JABBER']
      self.msn        = card['X-MSN']
      if raw_socials[:facebook] =~ FACEBOOK_URL
        self.facebook = $3 || $4
      end
      # self.soundcloud  = raw_socials[:soundcloud]
    end

    card.telephones.each do |telephone|
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
        (self.additional_data[:tel_malcious] ||= {}).tap do |hash|
          hash[key] = telephone.to_s
        end
      end
    end

    card.emails.each do |email|
      key   = email.location.sort.join("_").downcase
      value = email.to_s
      if !self.email
        self.email = value
      else
        (self.additional_data[:email] ||= {}).tap do |hash|
          hash[key] = value
        end
      end
    end

    card.urls.each do |url|
      value = url.uri.delete('\\').downcase
      if value =~ FACEBOOK_URL
        self.facebook = $3 || $4
      elsif !self.url
        self.url = value
      else
        (self.additional_data[:url] ||= {}).tap do |hash|
          hash[hash.size.to_s] = value
        end
      end
    end

    card.addresses do |address, key|
      if !self.street && !self.plz && !self.city && !self.country
        self.street  = address.street
        self.plz     = address.postalcode
        self.city    = address.locality
        self.country = address.country
      else
        (self.additional_data[:addresses] ||= {}).tap do |hash|
          hash[hash.size.to_s] = {
            :street  => address.street,
            :plz     => address.postalcode,
            :city    => address.locality,
            :country => address.country,
          }
        end
      end
    end

    card.photos.each do |photo|
      self.pictures.build(:data => photo).tap do |picture|
        if (format = photo.format) && !format.empty?
          picture.format = format
        end
      end
    end
  end

  def vcard
    Vcard::Vcard::Maker.make2 do |card|
      card.add_name do |name|
        name.given  = first_name
        name.family = last_name
      end
      card.nickname = nick_name if nick_name
      card.org      = company   if company

      card.add_field ::Vcard::DirectoryInfo::Field.create( "CATEGORIES", tags ) if !tags.empty?
      card.add_note(notes)      if notes

      card.birthday = Date.parse(birthday) if !birthday.empty?

      card.add_tel(tel_1)   { |t| t.location = 'mobile'; t.preferred = true } if tel_1
      card.add_tel(tel_2)   { |t| t.location = 'home';   t.preferred = true } if tel_2
      card.add_email(email) { |e| e.location = 'home';   e.preferred = true } if email
      card.add_url(url) if url

      if street || plz || city || country
        card.add_addr do |addr|
          addr.preferred  = true
          addr.location   = 'home'
          addr.street     = street  if street
          addr.postalcode = plz     if plz
          addr.locality   = city    if city
          addr.country    = country if country
        end
      end

      if photo = pictures.first
        card.add_photo { |p| p.image = photo.data; p.type = photo.format || 'JPEG' }
      end

      card.add_field ::Vcard::DirectoryInfo::Field.create( "REV", updated_at )
      card.add_field ::Vcard::DirectoryInfo::Field.create( "UID", uid )
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

end
