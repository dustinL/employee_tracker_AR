require 'active_record'
require 'rspec'
require 'shoulda-matchers'
require 'pry'

require 'employee'
require 'division'
require 'project'
require 'contribution'

database_configuration = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configuration["test"]
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Employee.all.each { |employee| employee.destroy }
    Division.all.each { |division| division.destroy }
    Project.all.each { |project| project.destroy }
    Contribution.all.each { |contribution| contribution.destroy }
  end
end
