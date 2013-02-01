require 'spec_helper'

describe "principals index" do
  include AcceptanceHelper

  describe "success scenario" do
    context "propfind 1" do
      subject do
        header "Content-Type", "text/xml"
        propfind "/principals", <<-XML
<?xml version="1.0" encoding="UTF-8"?>
<A:propfind xmlns:A="DAV:">
  <A:prop>
    <A:current-user-principal/>
    <A:principal-URL/>
    <A:resourcetype/>
  </A:prop>
</A:propfind>
XML
      end

      its(:status) { should == 207 }
      its(:body) { should == <<-XML
<D:multistatus xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav" xmlns:APPLE1="http://calendarserver.org/ns/">
  <D:response>
    <D:href>/</D:href>
    <D:propstat>
      <D:prop>
        <D:current-user-principal>
          <D:href>/</D:href>
        </D:current-user-principal>
        <D:principal-URL>
          <D:href>/</D:href>
        </D:principal-URL>
        <D:resourcetype>
          <D:collection />
          <D:principal />
        </D:resourcetype>
      </D:prop>
      <D:status>HTTP/1.0 200 OK</D:status>
    </D:propstat>
  </D:response>
</D:multistatus>
XML
      }
    end

    context "options 2" do
      let(:header) { debugger; subject.header }

      subject do
        options "/"
      end

      its(:status) { should == 200 }

      # it { header["Dav"].should == "1, 2, access-control, addressbook" }
      it { header["Allow"].should == "OPTIONS,HEAD,GET,PUT,POST,DELETE,PROPFIND,PROPPATCH,MKCOL,COPY,MOVE,LOCK,UNLOCK" }
      # it { header["Ms-Author-Via"].should == "DAV" }
    end
  end

  #######################################################################

  describe "error scenario" do
    # ...
  end
end
