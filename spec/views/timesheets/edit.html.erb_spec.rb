require 'spec_helper'

describe "timesheets/edit" do
  before(:each) do
    @timesheet = assign(:timesheet, stub_model(Timesheet,
      :description => "MyText"
    ))
  end

  it "renders the edit timesheet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", timesheet_path(@timesheet), "post" do
      assert_select "textarea#timesheet_description[name=?]", "timesheet[description]"
    end
  end
end
