require 'spec_helper'

describe AppsController do
  describe "#index" do
    it "should render without error" do
      get :index
    end
  end
end
