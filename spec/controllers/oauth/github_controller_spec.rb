require 'spec_helper'

describe Oauth::GithubController do
  describe "#callback" do
    it "should render JS to pass the auth code back to the opener" do
      get :callback, code: 'ABC123'
      response.body.should =~ /window.opener.postMessage\('ABC123', "\*"\);/
      response.body.should =~ /window.close\(\);/
    end

    it "should not allow non-alphanumerics as the code" do
      lambda {
        get :callback, code: '<evil>injection</attempt>'
      }.should raise_error
    end
  end

  describe "#exchange" do
    it "should turn a auth_code into a access token via Github's OAuth API" do
      stub = stub_request(:post, "github.com")
      stub_request(:post, "https://github.com/login/oauth/access_token").
        with(:body => "client_id=fffaaabbb&client_secret=fffaaabbb123&code=ABC123",
             :headers => {'Accept'=>'*/*'}).
        to_return(:status => 200, :body => "access_token=def456", :headers => {})
      post :exchange, code: 'ABC123'
      response.body.should == 'def456' #TODO JSON response
    end

    it "should give useful feedback when client id is missing" do
      stub = stub_request(:post, "github.com")
      stub_request(:post, "https://github.com/login/oauth/access_token").
        to_return(:status => 404, :body => "", :headers => {})
      post :exchange, code: 'ABC123'
      response.should be_error
      response.body.should =~ /Github API call failed. Be sure that your GitHub API credentials are set properly./ # TODO JSON response
    end
  end
end
