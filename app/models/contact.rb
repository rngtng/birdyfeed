# encoding: utf-8

require 'date'

class Contact < ActiveRecord::Base
  serialize :social, DataSerializer
  store_accessor :social, :skype, :twitter, :icq, :jabber, :msn, :facebook, :soundcloud

  serialize :additional_data, DataSerializer

  has_one  :original_vcard, :autosave => true, :dependent => :destroy
  has_many :pictures,       :autosave => true, :dependent => :destroy
  belongs_to :contact_account

  validates :uid, :presence => true, :uniqueness => true

  def import(card_string)
    card = Mapper::Card.new(card_string)

    self.first_name = card.first_name
    self.last_name  = card.last_name
    self.nick_name  = card.nick_name
    self.company    = card.company
    self.birthday   = card.birthday
    self.notes      = card.notes

    self.tel_1, *mobiles    = card.mobiles
    self.tel_2, *telephones = card.telephones
    self.email, *emails     = card.emails
    self.url,   *urls       = card.urls
    address,    *addresses  = card.addresses

    if address
      self.street     = address[:street]
      self.plz        = address[:postcode]
      self.city       = address[:city]
      self.country    = address[:country]
    end

    self.msn        = card.msn
    self.jabber     = card.jabber
    self.icq        = card.icq
    self.skype      = card.skype
    self.facebook   = card.facebook
    self.twitter    = card.twitter
    self.soundcloud = card.soundcloud

    self.tags       = Array(card.categories).join(",")

    self.additional_data = {
      :mobiles    => mobiles,
      :telephones => telephones,
      :malcious   => card.malcious,
      :emails     => emails,
      :urls       => urls,
      :addresses  => addresses,
    }

    # if photo = card.photos.first
    #   pictures.build(:data => photo[:data], :format => photo[:format])
    # end
  end

  def new_uid
    ("%04d-%s-%s" % [id, first_name,last_name]).downcase.gsub(/[ äöüß]/, {
      " " => "-",
      "ä" => "ae",
      "ö" => "oe",
      "ü" => "ue",
      "ß" => "ss",
    })
  end

  def vcard
    Vcard::Vcard::Maker.make2 do |card|
      card.add_name do |name|
        name.given  = self.first_name
        name.family = self.last_name
        name.suffix = self.id.to_s
      end
      card.nickname = self.nick_name if nick_name
      card.org      = self.company   if company

      # debugger

      tags = "Test"

      card.add_field ::Vcard::DirectoryInfo::Field.create("CATEGORIES", tags) if !self.tags.blank?
      card.add_note(notes) if self.notes

      card.birthday = Date.parse(birthday) if !self.birthday.blank?

      card.add_tel(tel_1)   { |t| t.location = 'mobile'; t.preferred = true } if self.tel_1
      card.add_tel(tel_2)   { |t| t.location = 'home';   t.preferred = true } if self.tel_2
      card.add_email(email) { |e| e.location = 'home';   e.preferred = true } if self.email
      card.add_url(url) if self.url

      card.add_addr do |addr|
        addr.preferred  = true
        addr.location   = 'home'
        addr.street     = self.street  if self.street
        addr.postalcode = self.plz     if self.plz
        addr.locality   = self.city    if self.city
        addr.country    = self.country if self.country
      end

      if photo = self.pictures.first
        card.add_photo { |p| p.image = photo.data; p.type = photo.format }
      end

      # TODO add socials

      card.add_field ::Vcard::DirectoryInfo::Field.create( "REV", self.updated_at || Time.now )
      card.add_field ::Vcard::DirectoryInfo::Field.create( "UID", self.new_uid )
    end.to_s
  end
end
