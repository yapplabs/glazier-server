require 'spec_helper'

describe Authentication do

  class AuthenticationSpecHost < ActionController::API
    include ActionController::Cookies
    include Authentication
    public :current_user, :current_user=
    def secret_token
      'abc123'
    end

    attr_accessor :cookies, :session
    def initialize
      self.cookies = ActionDispatch::Cookies::CookieJar.new
    end
  end


  subject { AuthenticationSpecHost.new }
  let(:user) {
    User.create(
      github_login: 'stefanpenner',
      github_id: 4321,
      email: 'stefanpenner@gmail.com'
    )
  }
  describe "#current_user" do
    it "should read current user from the cookie" do
      subject.cookies[:login] = Authentication.generate_cookie_value(user, subject.secret_token)
      subject.current_user.should == user
    end
  end

  describe "#current_user=" do
    it "should assign the current user" do
      subject.current_user = user
      serializable_hash = UserSerializer.new(user).serializable_hash
      json_data_from_cookie = ActiveSupport::JSON.decode(subject.cookies[:login].split('-', 2).last, symbolize_keys: true)
      json_data_from_cookie.should == serializable_hash
      subject.current_user.should == user
    end
  end
end
