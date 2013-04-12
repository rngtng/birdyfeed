# encoding: utf-8

require 'spec_helper'

describe Contact do
  let(:account)  { create(:contact_account) }
  let(:raw_card) { File.read("spec/fixtures/card.vcf").to_s }
  let(:contact)  { build(:contact, :id => 1)  }

  describe "#create" do
    subject { account.contacts.create(:uid => "asd") }

    it { expect { subject }.to change { account.contacts.count } }
  end

  describe "#import" do
    let(:expected_notes) { <<-EOF
Heikes ExFreund
Chemiker uni

WLAN:
183ea34ff714d

31383345413334464637313444
EOF
    }

    subject { contact }

    before do
      contact.import(raw_card)
    end

    its(:first_name) { should == "Christoph" }
    its(:last_name)  { should == "Müller" }
    its(:nick_name)  { should == "nille" }
    its(:company)    { should == "AvocadoStore.de" }
    its(:birthday)   { should == "1980-06-04" }
    its(:notes)      { should == expected_notes.strip }
    its(:tags)       { should == "My Contacts" }

    its(:tel_1)      { should == "+491735332818" }
    its(:tel_2)      { should == "+4989214343729" }
    its(:email)      { should == "masdyer_chtoph@hotmail.com" }
    its(:url)        { should == "http://anotherone.com/" }

    its(:street)     { should == "Einsteinstraße 119" }
    its(:plz)        { should == "81675" }
    its(:city)       { should == "München" }
    its(:country)    { should == "" }

    its(:msn)        { should == "mayer_chrsfah@hotmail.com" }
    its(:jabber)     { should == "elthl@jabber.fsinf.de"  }
    its(:icq)        { should == "108890559"  }
    its(:skype)      { should == "chrisma4"  }
    its(:facebook)   { should == "1836684010"  }
    # TODO twitter
    # TODO soundcloud

    its(:additional_data) { should == {
        :addresses  => [{:street=>"3 rue du chat", :postcode=>"90880", :city=>"Dris", :country=>"FRANCE"}],
        :emails     => ["chtoph@hotmail.com"],
        :malcious   => ["+49 (89) 1234567890"],
        :mobiles    => [],
        :telephones => ["+4989414563446"],
        :urls       => ["http://nillesnotizen.wordpress.com/"],
      }
    }

    its(:new_uid) { should == "0001-christoph-mueller" }
  end

  describe "#vcard" do
    subject { contact.vcard }

    before do
      Time.stub(:now).and_return(Time.parse("2012-12-12 12:00"))
      contact.import(raw_card)
    end

    it { should == <<-EOF
BEGIN:VCARD
VERSION:3.0
N:Müller;Christoph;;;1
FN:Christoph Müller, 1
NICKNAME:nille
ORG:AvocadoStore.de
CATEGORIES:Test
NOTE:Heikes ExFreund\\nChemiker uni\\n\\nWLAN:\\n183ea34ff714d\\n\\n3138334541333
 4464637313444
BDAY:19800604
TEL;TYPE=mobile,pref:+491735332818
TEL;TYPE=home,pref:+4989214343729
EMAIL;TYPE=home,pref:masdyer_chtoph@hotmail.com
URL:http://anotherone.com/
ADR;TYPE=home,pref:;;Einsteinstraße 119;München;;81675;
REV:20121212T120000
UID:0001-christoph-mueller
END:VCARD
EOF
   }

  end
end
