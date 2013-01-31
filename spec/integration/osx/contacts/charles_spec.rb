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
        method   = transaction.attributes["method"].value #.downcase
        path     = transaction.attributes["path"].value
        request  = transaction.search("request").first
        headers  = request.attributes
        # remove body , header size
        body     = request.search("body").first

        subject do
          headers.each do |name, value|
            puts name
          end
          send method, path, body
        end

        response = transaction.search("response").first
        status   = response.attributes["status"].value
        headers  = request.attributes
        body     = response.search("body").first

        its(:status) { should == status }
        headers.each do |name, value|
            puts name
        end
        its(:body) { should == body }

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
