require 'spec_helper'

describe "timesheets/index" do
  before(:each) do
    assign(:timesheets, [
      stub_model(Timesheet,
        :description => "MyText"
      ),
      stub_model(Timesheet,
        :description => "MyText"
      )
    ])
  end

  it "renders a list of timesheets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
