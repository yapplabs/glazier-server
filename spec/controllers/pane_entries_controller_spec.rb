require 'spec_helper'

describe PaneEntriesController do
  let(:dashboard) { create(:dashboard_with_default_panes)}
  let(:pane) { dashboard.sections.first.panes.first }
  let(:user) do
    dashboard.user_dashboards.first.user
  end
  describe "When a user is logged in" do
    before do
      controller.stub(current_user: user)
    end

    describe '#update' do
      it "adds a single private user key/value pair" do
        lambda {
          put :update, data: {mykey: 'value'}, pane_id: pane.id
          response.should be_success
        }.should change(PaneEntry, :count).by 1

        card_entry = PaneEntry.last
        card_entry.key.should == 'mykey'
      end

      it "adds multiple private user key/value pairs" do
        lambda {
          put :update, data: {mykey: 'value', anotherkey: 'anotherval'}, pane_id: pane.id
          response.should be_success
        }.should change(PaneEntry, :count).by 2
      end

      it "updates values for keys that already exist" do
        pane_id = pane.id
        put :update, data: {mykey: 'value'}, pane_id: pane_id
        response.should be_success

        lambda {
          put :update, data: {mykey: 'newvalue'}, pane_id: pane_id
          response.should be_success
        }.should_not change(PaneEntry, :count)

        card_entry = PaneEntry.last
        card_entry.value.should == 'newvalue'
      end

      it "returns error when no data provided" do
        lambda {
          put :update, pane_id: pane.id
          response.code.should == "400"
        }.should_not change(PaneEntry, :count)
      end
    end
  end
end
