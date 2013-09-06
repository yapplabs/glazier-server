require 'spec_helper'

describe SectionsController do
  describe "#update" do
    let(:dashboard) { create(:dashboard_with_default_panes) }
    let(:section) { create(:section, name: 'foo', slug: 'foo', container_type: "board", dashboard_id: dashboard.repository) }

    it "should update the name of the section" do
      user = dashboard.users.first
      controller.stub(current_user: user)

      put :update, id:  section.id, section: { name: "bar", slug: "bar", container_type: "not-allowed", dashboard_id: "not-allowed" }
      response.should be_success

      section.reload
      section.name.should == 'bar'
      section.slug.should == 'bar'
      section.container_type.should == 'board' # will not be changed via PUT
      section.dashboard_id.should == dashboard.repository # will not be changed via PUT
    end
  end
end
