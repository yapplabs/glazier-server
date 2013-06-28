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

    describe '#update_user_data' do
      it "raises an error when there is no user" do
        lambda {
          post :update_user_data, data: {mykey: 'value'}, pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9'
        }.should raise_error
      end
    end

    describe '#remove_user_data' do
      it "raises an error when there is no user" do
        lambda {
          delete :remove_user_data, key: 'value', pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9'
        }.should raise_error
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

    describe '#update_user_data' do
      it "adds a single private user key/value pair" do
        lambda {
          post :update_user_data, data: {mykey: 'value'}, pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9'
          response.should be_success
        }.should change(PaneUserEntry, :count).by 1

        card_entry = PaneUserEntry.last
        card_entry.key.should == 'mykey'
      end

      it "adds multiple private user key/value pairs" do
        lambda {
          post :update_user_data, data: {mykey: 'value', anotherkey: 'anotherval'}, pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9'
          response.should be_success
        }.should change(PaneUserEntry, :count).by 2
      end

      it "updates values for keys that already exist" do
        post :update_user_data, data: {mykey: 'value'}, pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9'
        response.should be_success

        lambda {
          post :update_user_data, data: {mykey: 'newvalue'}, pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9'
          response.should be_success
        }.should_not change(PaneUserEntry, :count)

        card_entry = PaneUserEntry.last
        card_entry.value.should == 'newvalue'
      end
    end

    describe '#remove_user_data' do
      it "removes a PaneUserEntry if one matches" do
        PaneUserEntry.create(key: 'was-added', pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9') {|u| u.github_id = 123 }

        lambda {
          delete :remove_user_data, key: 'was-added', pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9'
          response.should be_success
        }.should change(PaneUserEntry, :count).by(-1)
      end

      it "completes silently if no PaneUserEntry matches" do
        lambda {
          delete :remove_user_data, key: 'never-added', pane_id: '28c94114-d49b-11e2-ac01-9fc6e17420e9'
          response.should be_success
        }.should_not change(PaneUserEntry, :count)
      end
    end
  end
end
