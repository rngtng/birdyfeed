require 'spec_helper'

require "nokogiri"

describe "principals index" do
  # include AcceptanceHelper

  shared_examples_for :charles_trace do |file|
    # let(:fixture_data) { File.read("spec/fixtures/#{file}") }

    fixture_data = File.read("spec/fixtures/#{file}")
    doc = Nokogiri.XML(fixture_data)
    transactions = doc.elements.first.elements

    transactions.each do |transaction|
      status   = transaction.attributes["status"].value

      if status == "Complete"
        # skipt when not
        method   = transaction.attributes["method"].value.downcase
        path     = transaction.attributes["path"].value
        request  = transaction.search("request").first
        request_headers   = request.attributes  # remove body , header size
        response = transaction.search("response").first
        response_headers  = request.attributes

        context "calling #{method} on #{path}" do
          let(:response_status) { response.attributes["status"].value }
          let(:request_body)    { request.search("body").first }
          let(:response_status) { response.attributes["status"].value }
          let(:response_body)   { response.search("body").first }

          subject do
            headers.each do |name, value|
              puts name
            end
            send method, path, request_body
          end

          its(:status) { should == response_status }
          headers.each do |name, value|
              puts name
          end
          its(:body) { should == response_body }
        end

        debugger

      else
        puts "-------------------------------------------"
        puts "skipped #{status} -------------------------"
        puts "-------------------------------------------"
      end

    end

  end


  describe "success scenario" do

    it_behaves_like :charles_trace, "charles/dav4rails.xml"

  end

end
