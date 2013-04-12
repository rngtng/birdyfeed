require 'spec_helper'
require "nokogiri"

shared_examples_for :charles_trace do |file|
  # let(:fixture_data) { File.read("spec/fixtures/#{file}") }

  fixture_data = File.read("spec/fixtures/#{file}")
  doc = Nokogiri.XML(fixture_data)
  transactions = doc.elements.first.elements

  transactions.each do |transaction|
    status   = transaction.attributes["status"].value

    if status == "Complete"
      # skip when not
      method   = transaction.attributes["method"].value.downcase
      path     = transaction.attributes["path"].value
      request  = transaction.search("request").first
      request_headers  = request.attributes.delete_if { |key, value|  %w(headers body).include?(key) }
      response = transaction.search("response").first
      response_headers = request.attributes.delete_if { |key, value|  %w(headers body).include?(key) }

      context "calling #{method} on #{path}" do
        let(:response_status) { response.attributes["status"].value }
        let(:request_body)    { request.search("body").first }
        let(:response_status) { response.attributes["status"].value }
        let(:response_body)   { response.search("body").first }

        subject do
          request_headers.each do |name, value|
            header name, value
          end
          send method, path, request_body.to_xml
        end

        its(:status) { should == response_status }
        response_headers.each do |name, value|
            puts name
        end
        its(:body) { should == response_body.to_xml }
      end

      debugger

    else
      puts "-------------------------------------------"
      puts "skipped #{status} -------------------------"
      puts "-------------------------------------------"
    end

  end
end

describe "principals index" do
  include AcceptanceHelper


  describe "success scenario" do
    it_behaves_like :charles_trace, "charles/dav4rails.xml"

  end

end
