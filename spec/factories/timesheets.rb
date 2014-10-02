# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timesheet do
    date "2014-10-01"
    timein "2014-10-01 01:33:40"
    timeout "2014-10-01 01:33:40"
    description "MyText"
  end
end
