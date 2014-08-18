require 'active_record'
require './lib/employee'
require 'pry'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration["development"]
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "Welcome to the Employee Tracker!"
  menu
end

def menu
  choice = nil
  until choice == 'x'
    puts "Press 'e' to add an employee, 'l' to list your employees."
    puts "Press 'x' to exit."
    choice = gets.chomp
    case choice
    when 'e'
      add
    when 'l'
      list
    when 'x'
      puts "Good-bye!"
    else
      puts "Sorry, that wasn't a valid option."
    end
  end
end

def add
  puts "Type in the new employee name:"
  employee_name = gets.chomp
  employee = Employee.new({:name => employee_name})
  employee.save
  puts "'#{employee.name}' has been added to your To Do list."
end

def list
  puts "Here are all your employees:"
  employees = Employee.all
  employees.each { |employee| puts employee.name }
end

welcome
