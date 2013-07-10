require 'spec_helper'

describe PaneTypeUserEntriesController do
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
    describe '#update' do
      it "raises an error when there is no user" do
        put :update, data: {mykey: 'value'}, pane_type_name: 'foo'
        response.code.should == "401"
      end
    end

    describe '#destroy' do
      it "raises an error when there is no user" do
        delete :destroy, key: 'value', pane_type_name: 'foo'
        response.code.should == "401"
      end
    end

  end

  describe "When a user is logged in" do
    before do
      controller.stub(current_user: user)
    end

    describe '#update' do
      it "adds a single private user key/value pair" do
        lambda {
          put :update, data: {mykey: 'value'}, pane_type_name: 'foo'
          response.should be_success
        }.should change(PaneTypeUserEntry, :count).by 1

        card_entry = PaneTypeUserEntry.last
        card_entry.key.should == 'mykey'
      end

      it "adds multiple private user key/value pairs" do
        lambda {
          put :update, data: {mykey: 'value', anotherkey: 'anotherval'}, pane_type_name: 'foo'
          response.should be_success
        }.should change(PaneTypeUserEntry, :count).by 2
      end

      it "updates values for keys that already exist" do
        put :update, data: {mykey: 'value'}, pane_type_name: 'foo'
        response.should be_success

        lambda {
          put :update, data: {mykey: 'newvalue'}, pane_type_name: 'foo'
          response.should be_success
        }.should_not change(PaneTypeUserEntry, :count)

        card_entry = PaneTypeUserEntry.last
        card_entry.value.should == 'newvalue'
      end
    end

    describe '#destroy' do
      it "removes a PaneTypeUserEntry if one matches" do
        PaneTypeUserEntry.create do |entry|
          entry.github_id = 123
          entry.key = 'was-added'
          entry.pane_type_name = 'foo'
        end

        lambda {
          delete :destroy, key: 'was-added', pane_type_name: 'foo'
          response.should be_success
        }.should change(PaneTypeUserEntry, :count).by(-1)
      end

      it "completes silently if no PaneTypeUserEntry matches" do
        lambda {
          delete :destroy, key: 'never-added', pane_type_name: 'foo'
          response.should be_success
        }.should_not change(PaneTypeUserEntry, :count)
      end
    end
  end
end
