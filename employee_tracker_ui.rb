require 'active_record'
require './lib/employee'
require './lib/division'
require './lib/project'
require './lib/contribution'
require 'pry'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration["development"]
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  user_choice = nil
  until user_choice == 'x'

    puts "\n***Welcome to the Employee Tracker!***\n"
    puts "Press '1' to go to the divisions menu"
    puts "Press '2' to go to the employee menu"
    puts "Press '3' to go to the project menu"
    puts "Press 'x' to exit"

    user_choice = gets.chomp
    case user_choice
    when '1'
      divisions_menu
    when '2'
      employee_menu
    when '3'
      project_menu
    when 'x'
      puts "Goodbye."
    else
      puts "Sorry, not a valid entry."
    end
  end
end

def divisions_menu
  choice = nil
  until choice == 'x'
    puts "Press 'a' to add a division"
    puts "Press 'l' to list your divisions"
    puts "Press 'x' to exit"
    choice = gets.chomp
    case choice
    when 'a'
      add_division
    when 'l'
      list_divisions
    when 'x'
      puts "Good-bye!"
    else
      puts "Sorry, that wasn't a valid option."
    end
  end
end

def add_division
  puts "Type in the new division name:"
  division_name = gets.chomp
  division = Division.new({:name => division_name})
  division.save
  puts "'#{division.name}' has been added to your division list."
end

def list_divisions
  puts "\nHere are all your divisions:"
  divisions = Division.all
  divisions.each { |division| puts "#{division.id}. #{division.name}" }
  puts "\n"
  puts "Press '1' to list employees by division"
  puts "Press '2' to list all division projects"
  puts "Press '3' to add an employee to a division"
  user_choice = gets.chomp

  if user_choice == '1'
    list_employees_by_division
  elsif user_choice == '2'
    list_division_projects
  elsif user_choice == '3'
    add_employee
  else
    puts "Sorry, that wasn't a valid option.\n"
    list_divisions
  end
end

def list_employees_by_division
  puts "Enter the index number for the division you would like to view:\n"
  user_choice = gets.chomp
  selected_division = Division.find(user_choice)
  employees_list = selected_division.employees
  puts "*** Employees in #{selected_division.name} ***\n"
  employees_list.each do |employee|
    puts "#{employee.id}. #{employee.name}"
  end
  puts "\n\n"
end

def employee_menu
  choice = nil
  until choice == 'x'
    puts "Press 'e' to add an employee, 'l' to list your employees."
    puts "Press 'x' to exit."
    choice = gets.chomp
    case choice
    when 'e'
      add_employee
    when 'l'
      list_employees
    when 'x'
      puts "Good-bye!"
    else
      puts "Sorry, that wasn't a valid option."
    end
  end
end

def add_employee
  puts "Type in the new employee name:"
  employee_name = gets.chomp
  puts "\n\nPlease assign your employee to a division by entering in the index number:"
  divisions = Division.all
  divisions.each { |division| puts "#{division.id}. #{division.name}" }
  puts "\n\n"
  employee_assignment = gets.chomp.to_i
  employee = Employee.new({:name => employee_name, :division_id => employee_assignment})
  employee.save
  puts "'#{employee.name}' has been added."
end

def list_employees
  puts "\n\nHere are all your employees:"
  employees = Employee.all
  employees.each { |division| puts "#{division.id}. #{division.name}" }
  puts "\nWould you like to view projects by employee?"
  puts "[y] or [n]\n"
  user_choice = gets.chomp

  if user_choice == 'y'
    list_projects_by_employee
  elsif user_choice == 'n'
    employee_menu
  else
    puts "Sorry, that wasn't a valid option.\n"
    list_employees
  end
end

def project_menu
  choice = nil
  until choice == 'x'
    puts "Press 'a' to add an project, 'l' to list your projects."
    puts "Press 'x' to exit."
    choice = gets.chomp
    case choice
    when 'a'
      add_project
    when 'l'
      list_projects
    when 'x'
      puts "Good-bye!"
    else
      puts "Sorry, that wasn't a valid option."
    end
  end
end

def add_project
  puts "Type in the new project name:"
  project_name = gets.chomp
  puts "\n\nPlease assign your project to an employee by entering in the index number:"
  employees = Employee.all
  employees.each { |employee| puts "#{employee.id}. #{employee.name}" }
  puts "\n\n"
  project_assignment = gets.chomp.to_i
  selected_employee = Employee.find(project_assignment)
  puts "Please assign a start date (YYYY-MM-DD):"
  start_date = gets.chomp
  puts "Please assign an end date (YYYY-MM-DD):"
  end_date = gets.chomp
  project = Project.new({:name => project_name, :start_date => start_date, :end_date => end_date})
  project.save
  puts "Please enter the contribution for this employee:\n"
  user_contribution = gets.chomp
  new_contribution = Contribution.new({:employee_id => selected_employee.id, :project_id => project.id, :contribution => user_contribution})
  new_contribution.save
  puts "\n'#{project.name}' has been added.\n"
end

def list_projects
  puts "Here are all your projects:"
  projects = Project.all
  puts "Project ID | Project Name | Start Date | End Date"
  projects.each { |project| puts "#{project.id} #{project.name} #{project.start_date} #{project.end_date}" }
  puts "\nWould you like to view employees by project or add an employee to a project?"
  puts "Press '1' to view employees by project."
  puts "Press '2' to add an employee to a project."
  puts "Press 'x' to return to the project menu.\n"
  user_choice = gets.chomp

  if user_choice == '1'
    list_employees_by_project
  elsif user_choice == '2'
    add_employee_to_project
  elsif user_choice == 'x'
    project_menu
  else
    puts "Sorry, that wasn't a valid option.\n"
      list_projects
  end
end

def list_projects_by_employee
  puts "Enter the index number for the employee you would like to view:\n"
  user_choice = gets.chomp
  selected_employee = Employee.find(user_choice)
  puts "Would you like to view all projects or those within a specific date range?"
  puts "Press 'a' for all or 'd' for date range:"
  user_choice = gets.chomp

  if user_choice == 'a'
    projects_list = selected_employee.projects
    puts "*** Projects for #{selected_employee.name} ***\n"
    projects_list.each do |project|
      puts "#{project.id}. #{project.name}"
    end
  elsif user_choice == 'd'
    puts "\nEnter the start date: (YYYY-MM-DD)\n"
    start_date = gets.chomp
    puts "Enter the end date:"
    end_date = gets.chomp
    project_list = selected_employee.projects.where(:start_date => start_date..end_date)
    puts "Project ID | Project Name | Start Date | End Date"
    project_list.each { |project| puts "#{project.id}    #{project.name}    #{project.start_date}    #{project.end_date}" }
    puts "\n"
    employee_menu
  else
    puts "Sorry, that wasn't a valid option.\n"
    list_projects_by_employee
  end
end

def list_employees_by_project
  puts "Enter the index number for the project you would like to view:\n"
  user_choice = gets.chomp
  selected_project = Project.find(user_choice)
  employees_list = selected_project.employees
  employees_list.each do |employee|
    puts "*** Employees for #{selected_project.name} ***\n"
    puts "#{employee.id}. #{employee.name}"
  end
end

def add_employee_to_project
  puts "Enter the index number of the project for which you want to add an employee:"
  project_id = gets.chomp
  selected_project = Project.find(project_id)
  puts "\n"
  employees = Employee.all
  employees.each { |division| puts "#{division.id}. #{division.name}" }
  puts "\nPlease select an employee by index number to add them to the project:"
  user_choice = gets.chomp
  selected_employee = Employee.find(user_choice)
  selected_project.employees << selected_employee
  puts "\nEmployee #{selected_employee.name} has been added to #{selected_project.name}\n"
  project_menu
end

def list_division_projects
  puts "Enter the division number for which you'd like to see projects:"
  user_choice = gets.chomp
  selected_division = Division.find(user_choice)
  division_projects = Division.find(user_choice).projects
  division_projects.each do |project|
    puts "*** Projects for #{selected_division.name} ***"
    puts "#{project.name}"
  end
  puts "\n"
  divisions_menu
end

welcome
