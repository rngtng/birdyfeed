require 'spec_helper'

describe "principals index" do
  # include AcceptanceHelper

  describe "success scenario" do

      subject do
        # options "/"
        # propfind "/"
        propfind "/books/"
      end

      its(:status) { should == 200 }
      its(:body) { should == <<-JSON
        JSON
      }
    end
  end

  #######################################################################

  describe "error scenario" do
    # ...
  end
end
