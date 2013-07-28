require 'spec_helper'

describe PanesController do
  describe "#index" do
    let(:panes) do
      [create(:pane), create(:pane)]
    end

    it "returns json for multiple pane ids", :focus do
      get :index, ids: panes.map(&:id)
      response.should be_success

      json = JSON.parse(response.body)
      json['pane_types'].should have(2).items
      json['panes'].should have(2).items
    end
  end

  describe "#reorder" do
    let(:dashboard) { create(:dashboard_with_default_panes) }
    let(:user) { dashboard.users.first }
    before do
      controller.stub(current_user: user)
    end

    it "should update the position of the panes on a dashboard" do
      original_pane_ids = dashboard.panes.map(&:id)
      post :reorder, dashboard_id: dashboard.id, pane_ids: original_pane_ids.reverse
      response.should be_success
      dashboard.reload.panes(true).map(&:id).should == original_pane_ids.reverse
    end
  end
end
