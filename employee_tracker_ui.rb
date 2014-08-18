require 'active_record'
require './lib/employee'
require './lib/division'
require './lib/project'
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
  puts "\n\nHere are all your divisions:"
  divisions = Division.all
  divisions.each { |division| puts "#{division.id}. #{division.name}" }
  puts "\n\n"
  puts "Press '1' to list employees by division"
  puts "Press '2' to add an employee to a division"
  user_choice = gets.chomp

  if user_choice == '1'
    list_employees_by_division
  elsif user_choice == '2'
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
  project = Project.new({:name => project_name})
  project.save
  puts "'#{project.name}' has been added to your project list."
end

def list_projects
  puts "Here are all your projects:"
  projects = Project.all
  projects.each { |project| puts project.name }
end

def list_projects_by_employee
  puts "Enter the index number for the employee you would like to view:\n"
  user_choice = gets.chomp
  selected_employee = Employee.find(user_choice)
  projects_list = selected_employee.projects
  projects_list.each do |project|
    puts "*** Projects for #{selected_employee.name} ***\n"
    puts "#{project.id}. #{project.name}"
  end
end
welcome
