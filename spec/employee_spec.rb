require 'spec_helper'

describe Employee do
  it "belongs to a division" do
    division = Division.create({:name => "division"})
    employee = Employee.create({:name => "employee", :division_id => division.id})
    expect(employee.division).to eq division
  end
end
