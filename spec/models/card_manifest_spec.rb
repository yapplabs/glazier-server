require 'spec_helper'

describe CardManifest do
  describe "creation" do
    it "can be created" do
      lambda {
        CardManifest.create! do |card_manifest|
          card_manifest.name = "yapplabs/glazier"
          card_manifest.url = "http://something.cloudfront.com/card/yapplabs/glazier.json"
          card_manifest.manifest = "{}"
        end
      }.should change(CardManifest, :count).by(1)
    end
  end
end
