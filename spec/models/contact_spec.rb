require 'spec_helper'

describe Contact do
  let(:account) { create(:contact_account) }
  let(:raw_card) { File.read("spec/fixtures/card.vcr") }

  describe "#create" do
    subject { account.contacts.create(:uid => "asd") }

    it { expect { subject }.to change { account.contacts.count } }
  end

  describe "#import" do
    let(:contact) { build(:contact)  }

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
      contact.import(raw_card.to_s)
    end

    its(:first_name) { should == "Christoph" }
    its(:last_name)  { should == "Maier" }
    its(:nick_name)  { should == "nille" }
    its(:company)    { should == "AvocadoStore.de" }
    its(:birthday)   { should == "1980-06-04" }
    its(:notes)      { should == expected_notes.strip }
    its(:tags)       { should == "My Contacts" }

    its(:tel_1)     { should == "+491735332818" }
    its(:tel_2)     { should == "+4989214343729" }
    its(:email)     { should == "masdyer_chtoph@hotmail.com" }

    its(:url)      { should == "http://anotherone.com/" }

    its(:msn)      { should == "mayer_chrsfah@hotmail.com" }
    its(:jabber)   { should == "elthl@jabber.fsinf.de"  }
    its(:icq)      { should == "108890559"  }
    its(:skype)    { should == "chrisma4"  }
    its(:facebook) { should == "1836684010"  }
    its(:additional_data)    { should == {
       :tel_malcious => {"cell"=>"+49 (89) 1234567890"},
       :tel          => {"work"=>"+4989414563446"},
       :email        => {"work"=>"chtoph@hotmail.com"},
       :url          => {"0"=>"http://nillesnotizen.wordpress.com/"},
      }
    }
  end
end
