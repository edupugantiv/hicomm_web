# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

initial_time = Time.now

puts 'creating users...'

alan = User.create(
  :email => 'awei@rpdway.com',
  :password => 'password',
  :job_title => 'CEO',
  :location => 'Charlottesville, VA',
  :mobile => '5719260367',
  :first_name => 'Alan',
  :last_name => 'Wei'
)

vijay = User.create(
  :email => 'vijay1@yahoo.com',
  :password => '12345678'
)

rosalie = User.create(
  :email => 'rosalie@yahoo.com',
  :password => '12345678'
)

puts "created users in #{Time.now - initial_time} seconds"
initial_time = Time.now

puts 'creating projects...'

project = Project.create(
  :project_manager => alan,
  :name => 'Test',
  :location => 'Washington, D.C.',
  :scale => 'Small',
  :plan => 'Standard'
)

puts "created projects in #{Time.now - initial_time} seconds"

project.users << alan