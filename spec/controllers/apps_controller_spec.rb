require 'spec_helper'

describe AppsController do
  describe "#index" do
    it "should render with a meta tag containing the github client id" do
      get :index
      response.should be_ok
      response.body.should =~ /<meta name='github_client_id' content='#{Glazier::ApiCredentials::GITHUB_CLIENT_ID}'>/
    end
  end
end
