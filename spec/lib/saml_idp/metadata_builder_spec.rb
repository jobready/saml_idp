require 'spec_helper'
module SamlIdp
  describe MetadataBuilder do
    it "has a valid fresh" do
      subject.fresh.should_not be_empty
    end

    it "signs valid xml" do
      Saml::XML::Document.parse(subject.signed).valid_signature?(Default::FINGERPRINT).should be_truthy
    end

    it "includes logout element" do
      subject.configurator.single_logout_service_post_location = 'https://example.com/saml/logout'

      sls_element = Nokogiri::XML(subject.fresh).at_css("EntityDescriptor IDPSSODescriptor SingleLogoutService")
      sls_element.should_not be_nil
      
      sls_element.attributes["Location"].value.should eq 'https://example.com/saml/logout'
      sls_element.attributes["Binding"].value.should eq 'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST'
    end
  end
end
