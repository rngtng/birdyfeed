require 'spec_helper'

describe "principals index" do
  include AcceptanceHelper

  describe "root" do
    context "propfind" do
      subject do
        propfind "/"
      end

      its(:status) { should == 401 }

      context "authorized" do
        its(:status) { should == 301 }

        it { should redirect_to "/principals/tobi" }
      end
    end


    context "propfind" do
      subject do
        propfind "/principals"
      end

      its(:status) { should == 401 }

      context "authorized" do
        let(:header) { debugger; subject.header }

        its(:status) { should == 207 }
      end
    end
  end

  #######################################################################

end
