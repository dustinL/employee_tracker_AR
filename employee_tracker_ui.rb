require 'active_record'
require './lib/employee'
require './lib/division'
require 'pry'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration["development"]
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  user_choice = nil
  until user_choice == 'x'

    puts "\n***Welcome to the Employee Tracker!***\n"
    puts "Press '1' to go to the employee menu"
    puts "Press '2' to go to the divisions menu"
    puts "Press 'x' to exit"

    user_choice = gets.chomp
    case user_choice
    when '1'
      employee_menu
    when '2'
      divisions_menu
    when 'x'
      puts "Goodbye."
    else
      puts "Sorry, not a valid entry."
    end
  end
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
  employee = Employee.new({:name => employee_name})
  employee.save
  puts "'#{employee.name}' has been added to your employee list."
end

def list_employees
  puts "Here are all your employees:"
  employees = Employee.all
  employees.each { |employee| puts employee.name }
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
  puts "Here are all your divisions:"
  divisions = Division.all
  divisions.each { |division| puts division.name }
end

welcome
