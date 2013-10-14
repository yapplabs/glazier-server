require 'spec_helper'

describe SectionsController do
  let(:dashboard) { create(:dashboard_with_default_panes) }
  let(:section) { create(:section, name: 'foo', slug: 'foo', position: 0, container_type: "board", dashboard_id: dashboard.repository) }
  let(:section2) { create(:section, name: 'baz', slug: 'baz', position: 1, container_type: "board", dashboard_id: dashboard.repository) }

  before do
    user = dashboard.users.first
    controller.stub(current_user: user)
  end

  describe "#index" do
    it "should render dashboards" do
      get :index, ids:  [section.id, section2.id]
      response.should be_success
      JSON.parse(response.body)['sections'].size.should == 2
    end
  end

  describe "#update" do
    it "should update the name of the section" do
      put :update, id:  section.id, section: { name: "bar", slug: "bar", container_type: "not-allowed", dashboard_id: "not-allowed" }
      response.should be_success

      section.reload
      section.name.should == 'bar'
      section.slug.should == 'bar'
      section.container_type.should == 'board' # will not be changed via PUT
      section.dashboard_id.should == dashboard.repository # will not be changed via PUT
    end
  end

  describe "#update_all" do
    it "should bulk update a dashboard's sections" do
      put :update_all, sections: [
        {
          id: section.id,
          name: "Foo",
          slug: "foo",
          position: 1,
          container_type: "not-allowed",
          dashboard_id: "not-allowed"
        },
        {
          id: section2.id,
          name: "baz",
          slug: "baz",
          position: 0,
          container_type: "not-allowed",
          dashboard_id: "not-allowed"
        }
      ]
      response.should be_success

      section.reload
      section.name.should == 'Foo'
      section.slug.should == 'foo'
      section.position.should == 1
      section.container_type.should == 'board' # will not be changed via PUT
      section.dashboard_id.should == dashboard.repository # will not be changed via PUT

      section2.reload
      section2.name.should == 'baz'
      section2.slug.should == 'baz'
      section2.position.should == 0
      section2.container_type.should == 'board' # will not be changed via PUT
      section2.dashboard_id.should == dashboard.repository # will not be changed via PUT
    end
  end
end
