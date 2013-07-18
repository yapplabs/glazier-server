require 'spec_helper'

describe SessionsController do
  let!(:default_pane_types) do
    Dashboard::DEFAULT_PANE_TYPE_NAMES.each {|pane_type_name|
      create(:pane_type, name: pane_type_name)
    }
  end

  describe '#create' do
    let(:user_json) do
      <<-JS
        {
          "id": 1234,
          "login": "stefanpenner",
          "email": "stefanpenner@gmail.com"
        }
      JS
    end
    let(:user_repos_json) do
      <<-JS
        [
          {
            "full_name":"emberjs/ember.js",
            "permissions":{"admin":false,"push":true,"pull":true}
          }
        ]
      JS
    end
    it 'creates a user record for a github user who has not logged in before using the github access token' do
      stub_request(:get, "https://api.github.com/user").
        with(headers: {'Authorization'=>'token abcd'}).
        to_return(status: 200, body: user_json)


      stub_request(:get, "https://api.github.com/user/repos?type=public").
        with(headers: {'Authorization'=>'token abcd'}).
        to_return(status: 200, body: user_repos_json)

      stub_request(:get, "https://api.github.com/user/orgs").
        with(headers: {'Authorization'=>'token abcd'}).
        to_return(status: 200, body: '[]')

      lambda {
        post :create, github_access_token: 'abcd'
        response.should be_success
      }.should change(User, :count).by 1

      new_user = User.last

      json = JSON.parse(response.body)
      json.should eq(
        'user' => {
          'email' => 'stefanpenner@gmail.com',
          'github_access_token' => 'abcd',
          'github_id' => 1234,
          'github_login' => 'stefanpenner',
          'gravatar_id' => nil,
          'name' => nil,
          'editable_repositories' => ["emberjs/ember.js"]
        }
      )

      signed_user_json = cookies[:login]
      digest, user_json = signed_user_json.split('-', 2)

      ActiveSupport::JSON.decode(user_json).should eq("github_id" => 1234)

      controller.instance_eval do
        current_user.should == new_user
      end
    end

    it 'creates a dashboard if the user has push rights to one that is not yet in the Glazier system' do
      stub_request(:get, "https://api.github.com/user").
        with(headers: {'Authorization'=>'token abcd'}).
        to_return(status: 200, body: user_json)

      stub_request(:get, "https://api.github.com/user/repos?type=public").
        with(headers: {'Authorization'=>'token abcd'}).
        to_return(status: 200, body: user_repos_json)

      stub_request(:get, "https://api.github.com/user/orgs").
        with(headers: {'Authorization'=>'token abcd'}).
        to_return(status: 200, body: '[]')

      post :create, github_access_token: 'abcd'
      response.should be_success

      controller.instance_eval do
        dashboards = current_user.user_dashboards(true)
        dashboards.size.should == 1
        dashboards.first.repository.should == 'emberjs/ember.js'
      end
    end

    it 'removes a dashboard if the user no longer has push rights to one previously added to the Glazier database' do
      stub_request(:get, "https://api.github.com/user").
        with(headers: {'Authorization'=>'token abcd'}).
        to_return(status: 200, body: user_json)

      stub_request(:get, "https://api.github.com/user/repos?type=public").
        with(headers: {'Authorization'=>'token abcd'}).
        to_return(status: 200, body: user_repos_json)

      stub_request(:get, "https://api.github.com/user/orgs").
        with(headers: {'Authorization'=>'token abcd'}).
        to_return(status: 200, body: '[]')

      post :create, github_access_token: 'abcd'
      response.should be_success

      controller.instance_eval do
        dashboards = current_user.user_dashboards(true)
        dashboards.size.should == 1
        dashboards.first.repository.should == 'emberjs/ember.js'
      end

      stub_request(:get, "https://api.github.com/user/repos?type=public").
        with(headers: {'Authorization'=>'token abcd'}).
        to_return(status: 200, body: '[]')

      post :create, github_access_token: 'abcd'
      response.should be_success

      controller.instance_eval do
        dashboards = current_user.user_dashboards(true)
        dashboards.size.should == 0
      end
    end

    it 'handles invalid access tokens' do
      stub_request(:get, "https://api.github.com/user").
        with(:headers => {'Authorization'=>'token fakefake'}).
        to_return(:status => 401, :body => '{"message":"Bad credentials"}')

      post :create, github_access_token: 'fakefake', format: 'json'

      response.status.should eq(400)
    end

    it 'tells you if there is a missing access token' do
      post :create
    end
  end

  describe '#destroy' do
    before do
      request.cookies['login'] = 'some opaque login cookie'
    end

    it "clears out the session's user_id" do
      delete :destroy
      response.should be_success

      cookies[:login].should be_nil
    end
  end
end
