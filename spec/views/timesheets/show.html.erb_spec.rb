require 'spec_helper'

describe "timesheets/show" do
  before(:each) do
    @timesheet = assign(:timesheet, stub_model(Timesheet,
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
