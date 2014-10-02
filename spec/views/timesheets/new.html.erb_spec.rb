require 'spec_helper'

describe "timesheets/new" do
  before(:each) do
    assign(:timesheet, stub_model(Timesheet,
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new timesheet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", timesheets_path, "post" do
      assert_select "textarea#timesheet_description[name=?]", "timesheet[description]"
    end
  end
end
