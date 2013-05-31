require 'spec_helper'

describe SessionsController do
  describe '#create' do
    it 'creates a user record for a github user who has not logged in before using the github access token' do
      Services::Github.stub(:get_user_data) do
        {
          id: '1234',
          login: 'stefanpenner',
          email: 'stefanpenner@gmail.com'
        }
      end

      lambda {
        post :create, github_access_token: 'abcd'
        response.should be_success
      }.should change(User, :count).by 1

      new_user = User.last

      json = JSON.parse(response.body)
      json['user'].should == {
        'id' => new_user.id,
        'github_id' => '1234',
        'github_login' => 'stefanpenner'
      }

      session[:user_id].should == new_user.id
    end
  end
end
