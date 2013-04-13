require 'vcard'
require 'phonie'

module Mapper
  class Card
    FACEBOOK_URL = /facebook.com\/((profile.php\?id=(\d+))|(.+))/

    def initialize(card_string)
      @card = Vcard::Vcard.decode(card_string).first
    end

    def first_name
      @card.name.given
    end

    def last_name
      @card.name.family
    end

    def nick_name
      @card.nickname
    end

    def company
      Array(@card.org).first
    end

    def birthday
      if birthday = @card.birthday
        birthday.to_s
      end
    end

    def categories
      @card.categories.map do |c|
        c.gsub('\\', '')
      end
    end

    def notes
      @card.note.strip
    end

    #################### Contacts

    def mobiles
      raw_telephones[:mobiles]
    end

    def telephones
      raw_telephones[:telephones]
    end

    def malcious
      raw_telephones[:malcious]
    end

    #################### Socials

    def icq
      @card['X-ICQ']
    end

    def jabber
      @card['X-JABBER']
    end

    def msn
      @card['X-MSN']
    end

    def skype
      socials[:skype]
    end

    def facebook
      urls # extract FB from urls
      if socials[:facebook] =~ FACEBOOK_URL
        $3 || $4
      end
    end

    def twitter
      socials[:twitter]
    end

    def soundcloud
      socials[:soundcloud]
    end

    ###############################

    def socials
      @socials ||= @card.groups.inject({}) do |hash, group|
        pair = @card.fields.select { |l| l.group == group }.inject({}) do |lhash, field|
          key = (field.name.upcase == 'X-ABLABEL') ? :key : :value
          if !(field.value.downcase =~ /homepage/i)
            lhash[key] ||= field.value.downcase.delete('\\')
          end
          lhash
        end
        if key = pair[:key]
          hash[key.to_sym] = pair[:value]
        end
        hash
      end
    end

    def raw_telephones
      @raw_telephones ||= @card.telephones.inject({}) do |hash, telephone|
        key = telephone.location.sort.join("_").downcase
        if value = Phonie::Phone.parse(telephone.to_s)
          if value.is_mobile?
            hash[:mobiles] ||= []
            hash[:mobiles] << value.to_s
          else
            hash[:telephones] ||= []
            hash[:telephones] << value.to_s
          end
        elsif !key.blank?
          hash[:malcious] ||= []
          hash[:malcious] << telephone.to_s
        end
        hash
      end
    end

    def emails
      @card.emails.map(&:to_s)
    end

    def addresses
      @card.addresses.inject([]) do |array, address|
        array << {
          :street   => address.street,
          :postcode => address.postalcode,
          :city     => address.locality,
          :country  => address.country,
        }
        array
      end
    end

    def urls
      @urls ||= @card.urls.inject([]) do |array, url|
        value = url.uri.delete('\\').downcase
        if value =~ FACEBOOK_URL
          socials[:facebook] = value
        else
          array << value
        end
        array
      end
    end

    def photos
      @card.photos.inject([]) do |array, photo|
        {
          :data   => photo.to_s,
          :format => photo.format,
        }
      end
    end

  end
end
