require 'spec_helper'

describe CardsController do
  let!(:dashboard) do
    Dashboard.create do |dashboard|
      dashboard.repository = 'foo/bar'
      dashboard.panes.new do |pane|
        pane.id = '28c94114-d49b-11e2-ac01-9fc6e17420e9'
        pane.create_pane_type do |pane_type|
          pane_type.name = 'foo'
          pane_type.manifest = '{}'
          pane_type.url = 'http://foo.com/manifest.json'
        end
      end
    end
  end

  let!(:user) do
    User.create do |user|
      user.id = 123
    end
  end

  describe "when user is not logged in" do
    describe "#show" do
      it "returns a hash with no private data" do
        get :show, pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9'
        response.should be_success

        json = JSON.parse(response.body)
        json['card']['private'].should == {}
      end
    end
  end

  describe "When a user is logged in" do
    before do
      controller.stub(:current_user) do
        {github_id: 123}
      end
    end

    describe "#show" do
      it "returns http success" do
        PaneUserEntry.create(pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9', key: 'mykey', value: 'my value') {|u| u.github_id = 123 }

        get :show, pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9'
        response.should be_success

        json = JSON.parse(response.body)
        json['card']['private']['mykey'].should == "my value"
      end
    end
  end
end
