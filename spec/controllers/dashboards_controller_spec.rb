require 'spec_helper'

describe DashboardsController do
  before do
    dashboard = Dashboard.create! do |d|
      d.repository = 'test/test'
    end
    ['glazier/test-card', 'yapplabs/github-issues', 'yapplabs/github-stars'].each do |name|
      CardManifest.create! do |cm|
        cm.name = name
        cm.manifest = '{}'
        cm.url = "http://glassmaking.tst/#{name}"
      end
    end
    pane = Pane.create! do |p|
      p.card_manifest_name = 'glazier/test-card'
    end
    dashboard.panes << pane
  end
  describe '#show' do
    it "return an existing dashboard" do
      get :show, :id => 'test/test'

      response.should be_success
      response_json = JSON.parse(response.body)
      response_json.should have_key('dashboard')
      response_json.should have_key('panes')
      response_json['panes'].size.should == 1
    end

    it "creates a dashboard if one does not exist" do
      get :show, :id => 'test/does_not_exist'
      response.should be_success
      response_json = JSON.parse(response.body)
      response_json.should have_key('dashboard')
      response_json.should have_key('panes')
      response_json['panes'].size.should > 1
    end
  end
end
