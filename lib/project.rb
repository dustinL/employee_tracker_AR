class Project < ActiveRecord::Base
  # belongs_to(:employee)
  has_and_belongs_to_many :employees
end
