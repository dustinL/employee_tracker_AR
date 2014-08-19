require 'spec_helper'

describe Employee do
  it "belongs to a division" do
    division = Division.create({:name => "division"})
    employee = Employee.create({:name => "employee", :division_id => division.id})
    expect(employee.division).to eq division
  end

  # it { should have_and_belong_to_many :projects }


  it "can have many projects and belong to many projects" do
    division = Division.create({:name => "Sales"})
    employee = Employee.create({:name => "Michael Scott", :division_id => division.id})
    project = Project.create({:name => "Sell Paper"})
    project1 = Project.create({:name => "Manage"})
    employee.projects << project
    employee.projects << project1
    expect(employee.projects).to eq [project, project1]
    expect(project.employees).to eq [employee]
  end
end
