require 'spec_helper'

describe DashboardsController do
  let!(:dashboard) { create(:dashboard_with_default_panes) }

  describe '#show' do
    it "return an existing dashboard" do
      get :show, :id => dashboard.id

      response.should be_success
      response_json = JSON.parse(response.body)
      response_json.should have_key('dashboard')
      response_json.should have_key('panes')
      response_json['panes'].size.should == dashboard.panes.size
    end

    it "creates a dashboard if one does not exist" do
      stub_request(:head, "https://api.github.com/repos/test/does_not_exist?client_id=fffaaabbb&client_secret=fffaaabbb123").
        to_return(:status => 200, :body => "", :headers => {})
      get :show, :id => 'test/does_not_exist'
      response.should be_success
      response_json = JSON.parse(response.body)
      response_json.should have_key('dashboard')
      response_json.should have_key('panes')
      response_json['panes'].size.should > 1
    end
    context "with data" do
      let!(:dashboard) { create(:dashboard_with_data) }
      it "includes pane_entries, pane_type_user_entries, and pane_user_entries" do
        controller.stub current_user: User.last

        get :show, :id => dashboard.id

        response.should be_success
        response_json = JSON.parse(response.body)

        pane_json = response_json['panes'].first
        pane_json.should have_key('pane_entries')
        pane_json.should have_key('pane_user_entries')
        pane_json.should have_key('pane_type_user_entries')
        pane_json['pane_entries']['foo'].should eq('bar')
        pane_json['pane_user_entries']['foo_user'].should eq('bar_user')
        pane_json['pane_type_user_entries']['foo_type_user'].should eq('bar_type_user')
      end
    end
  end
end
