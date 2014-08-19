class Project < ActiveRecord::Base
  # belongs_to(:employee)
  has_many :contributions
  has_many :employees, through: :contributions
end
