require 'spec_helper'

describe Contribution do
  it { should belong_to :employee }
  it { should belong_to :project }

  it "can have many projects and belong to many projects" do
    division = Division.create({:name => "Sales"})
    employee = Employee.create({:name => "Michael Scott", :division_id => division.id})
    project = Project.create({:name => "Sell Paper"})
    project1 = Project.create({:name => "Manage"})
    contribution = Contribution.create({:employee_id => employee.id, :project_id => project.id, :contribution => "Sold paper"})
    contribution1 = Contribution.create({:employee_id => employee.id, :project_id => project1.id, :contribution => "Managed"})
    expect(employee.contributions).to eq [contribution, contribution1]
  end
end
