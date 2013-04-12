# encoding: utf-8

$:.unshift(File.expand_path("../../../lib", __FILE__))
require 'mapper/card'

describe Mapper::Card do
  let(:raw_card) { File.read("spec/fixtures/card.vcf") }

    let(:expected_notes) { <<-EOF
Heikes ExFreund
Chemiker uni

WLAN:
183ea34ff714d

31383345413334464637313444
EOF
    }

  subject { Mapper::Card.new(raw_card) }

  describe "#attributes" do
    its(:first_name) { should == "Christoph" }
    its(:last_name)  { should == "Müller" }
    its(:nick_name)  { should == "nille" }
    its(:company)    { should == "AvocadoStore.de" }
    its(:birthday)   { should == "1980-06-04" }
    its(:notes)      { should == expected_notes.strip }
    its(:categories) { should == ["My Contacts"] }

    its(:msn)        { should == "mayer_chrsfah@hotmail.com" }
    its(:jabber)     { should == "elthl@jabber.fsinf.de"  }
    its(:icq)        { should == "108890559"  }
    its(:skype)      { should == "chrisma4"  }
    its(:facebook)   { should == "1836684010"  }

    its(:socials)    { should == {
        :skype    => "chrisma4",
        :facebook => "http://www.facebook.com/profile.php?id=1836684010",
      }
    }

    its(:mobiles)    { should == ["+491735332818"] }
    its(:telephones) { should == ["+4989214343729", "+4989414563446"] }
    its(:malcious)   { should == ["+49 (89) 1234567890"] }

    its(:emails)     { should == ["masdyer_chtoph@hotmail.com", "chtoph@hotmail.com"] }

    its(:addresses)  { should == [
        {:street=>"Einsteinstraße 119", :postcode=>"81675", :city=>"München", :country=>""},
        {:street=>"3 rue du chat",      :postcode=>"90880", :city=>"Dris",    :country=>"FRANCE"}
      ]
     }

    its(:urls)       { should == ["http://anotherone.com/", "http://nillesnotizen.wordpress.com/"] }

  end
end
