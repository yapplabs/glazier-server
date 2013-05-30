require 'spec_helper'

describe CardsController do

  describe "#show" do
    it "returns http success" do
      CardEntry.create(card_id: 'abc', key: 'mykey', value: 'my value', access: 'private')

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

end
