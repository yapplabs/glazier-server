require 'spec_helper'

describe PaneType do
  describe "creation" do
    it "can be created" do
      lambda {
        PaneType.create! do |pane_type|
          pane_type.name = "yapplabs/glazier"
          pane_type.url = "http://something.cloudfront.com/card/yapplabs/glazier.json"
          pane_type.manifest = "{}"
        end
      }.should change(PaneType, :count).by(1)
    end
  end
end
