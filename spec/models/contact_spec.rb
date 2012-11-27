require 'spec_helper'

describe Contact do
  let(:account) { create(:contact_account) }
  let(:raw_card) { File.read("spec/fixtures/card.vcr") }

  describe "#create" do
    let(:contact) { account.contacts.create(:raw_card => raw_card) }
    subject { contact }

    it { expect { subject }.to change { account.contacts.count } }

    its(:first_name) { should == "Christoph" }
    its(:last_name)  { should == "Maier" }
    its(:nick_name)  { should == "nille" }
    its(:company)    { should == "AvocadoStore.de" }
    its(:birthday)   { should == "1980-06-04" }
    #its(:notes)      { should == "" }
    its(:tags)       { should == "My Contacts" }

    its(:tel_1)     { should == "+491735332818" }
    its(:tel_2)     { should == "+4989414563446" }

    its(:msn)      { should == "mayer_chrsfah@hotmail.com" }
    its(:jabber)   { should == "elthl@jabber.fsinf.de"  }
    its(:icq)      { should == "108890559"  }
    its(:skype)    { should == "chrisma4"  }
    its(:facebook) { should == "http\\\://www.facebook.com/profile.php?id=1836684010"  }
  end
end
