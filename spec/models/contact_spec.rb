require 'spec_helper'

describe Contact do
  let(:account) { create(:contact_account) }
  let(:raw_card) { File.read("spec/fixtures/card.vcr") }

  describe "#create" do
    let(:contact) { account.contacts.create(:raw_card => raw_card) }
    subject { contact }

    it { expect { subject }.to change { account.contacts.count } }

    its(:msn)      { should == "mayer_chrsfah@hotmail.com" }
    its(:jabber)   { should == "elthl@jabber.fsinf.de"  }
    its(:icq)      { should == "108890559"  }
    its(:skype)    { should == "chrisma4"  }
    its(:facebook) { should == "http\\\://www.facebook.com/profile.php?id=1836684010"  }
  end
end
