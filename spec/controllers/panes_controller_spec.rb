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
end
