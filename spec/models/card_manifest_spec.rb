require 'spec_helper'

describe CardManifest do
  describe "creation" do
    it "can be created" do
      lambda {
        CardManifest.create!(name: "yapplabs/glazier", manifest: "{}")
      }.should change(CardManifest, :count).by(1)
    end
  end
end
