require 'spec_helper'

describe SessionsController do
  describe '#create' do
    it 'creates a user record for a github user who has not logged in before using the github access token' do
      Services::Github.stub(:get_user_data) do
        {
          'id' => 1234,
          'login' => 'stefanpenner',
          'email' => 'stefanpenner@gmail.com'
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

    it 'handles invalid access tokens' do
      Services::Github.stub(:get_user_data) do
        raise "Bad credentials"
      end

      lambda {
        post :create, github_access_token: 'fakefake'
      }.should raise_error
    end

    it 'tells you if there is a missing access token' do
      lambda {
        post :create
      }.should raise_error
    end
  end

  describe '#destroy' do
    before do
      user = User.create(
        github_login: 'stefanpenner',
        github_id: 'abcd',
        email: 'stefanpenner@gmail.com'
      )
      session[:user_id] = user.id
    end

    it "clears out the session's user_id" do
      delete :destroy
      response.should be_success

      session[:user_id].should be_nil
    end
  end
end
