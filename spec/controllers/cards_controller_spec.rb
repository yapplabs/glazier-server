require 'spec_helper'

describe CardsController do

  describe "when user is not logged in" do
    describe "#show" do
      it "returns a hash with no private data" do
        get :show, card_id: 'abc'
        response.should be_success

        json = JSON.parse(response.body)
        json['card']['private'].should == {}
      end
    end

    describe '#update_user_data' do
      it "raises an error when there is no user" do
        lambda {
          post :update_user_data, data: {mykey: 'value'}, access: 'private', card_id: 'abc'
        }.should raise_error
      end
    end

    describe '#remove_user_data' do
      it "raises an error when there is no user" do
        lambda {
          delete :remove_user_data, key: 'value', access: 'private', card_id: 'abc'
        }.should raise_error
      end
    end

  end

  describe "When a user is logged in" do
    before do
      controller.stub(:current_user) do
        bob = Struct.new(:github_id).new
        bob.github_id = 123
        bob
      end
    end

    describe "#show" do
      it "returns http success" do
        CardEntry.create(card_id: 'abc', key: 'mykey', value: 'my value', access: 'private') {|u| u.github_id = 123 }

        get :show, card_id: 'abc'
        response.should be_success

        json = JSON.parse(response.body)
        json['card']['private']['mykey'].should == "my value"
      end
    end

    describe '#update_user_data' do
      it "adds a single private user key/value pair" do
        lambda {
          post :update_user_data, data: {mykey: 'value'}, access: 'private', card_id: 'abc'
          response.should be_success
        }.should change(CardEntry, :count).by 1

        card_entry = CardEntry.last
        card_entry.key.should == 'mykey'
      end

      it "adds multiple private user key/value pairs" do
        lambda {
          post :update_user_data, data: {mykey: 'value', anotherkey: 'anotherval'}, access: 'private', card_id: 'abc'
          response.should be_success
        }.should change(CardEntry, :count).by 2
      end

      it "raises an error with invalid access param" do
        lambda {
          post :update_user_data, data: {mykey: 'value'}, access: 'hacker', card_id: 'abc'
        }.should raise_error
      end

      it "updates values for keys that already exist" do
        post :update_user_data, data: {mykey: 'value'}, access: 'private', card_id: 'abc'
        response.should be_success

        lambda {
          post :update_user_data, data: {mykey: 'newvalue'}, access: 'private', card_id: 'abc'
          response.should be_success
        }.should_not change(CardEntry, :count)

        card_entry = CardEntry.last
        card_entry.value.should == 'newvalue'
      end
    end

    describe '#remove_user_data' do
      it "removes a CardEntry if one matches" do
        CardEntry.create(key: 'was-added', access: 'private', card_id: 'abc') {|u| u.github_id = 123 }

        lambda {
          delete :remove_user_data, key: 'was-added', access: 'private', card_id: 'abc'
          response.should be_success
        }.should change(CardEntry, :count).by(-1)
      end

      it "completes silently if no CardEntry matches" do
        lambda {
          delete :remove_user_data, key: 'never-added', access: 'private', card_id: 'abc'
          response.should be_success
        }.should_not change(CardEntry, :count)
      end

      it "raises an error with invalid access param" do
        lambda {
          delete :remove_user_data, key: 'never-added', access: 'haxor', card_id: 'abc'
        }.should raise_error
      end
    end
  end
end
