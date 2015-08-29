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
  :location => 'Charlottesville',
  :mobile => '5719260367',
  :first_name => 'Alan',
  :last_name => 'Wei'
)

20.times do
  first_name = Faker::Name.first_name
  User.create(
    :email => Faker::Internet.email(first_name),
    :password => 'password',
    :job_title => Faker::Name.title,
    :location => Faker::Address.city,
    :mobile => Faker::Number.number(10),
    :first_name => first_name,
    :last_name => Faker::Name.last_name
  )
end

puts "created users in #{Time.now - initial_time} seconds"
initial_time = Time.now

puts 'creating projects...'

users = User.all

10.times do
  project = Project.create(
    :project_manager => alan,
    :name => Faker::Company.name,
    :location => Faker::Address.city,
    :scale => ['Small', 'Medium', 'Large'].sample,
    :avatar => URI.parse(Faker::Company.logo),
    :plan => ['Standard', 'Premium'].sample
  )

  puts 'adding users to projects...'
  rand(0..10).times do
    user = users.sample
    project.users << user unless project.users.include? user
  end
end

30.times do
  project = Project.create(
    :project_manager => users.sample,
    :name => Faker::Company.name,
    :location => Faker::Address.city,
    :scale => ['Small', 'Medium', 'Large'].sample,
    :avatar => URI.parse(Faker::Company.logo),
    :plan => ['Standard', 'Premium'].sample
  )
  rand(0..10).times do
    user = users.sample
    project.users << user unless project.users.include? user
  end
end

puts "created projects in #{Time.now - initial_time} seconds"
initial_time = Time.now

puts 'creating conversations...'

projects = Project.all

50.times do
  conversation = Conversation.create(
    :name => Faker::Commerce.department,
    :project => projects.sample
  )

  puts 'adding users to conversations...'
  rand(0..conversation.project.users.size).times do
    user = conversation.project.users.sample
    conversation.users << user unless conversation.users.include? user
  end
end

puts "created conversations in #{Time.now - initial_time} seconds"
initial_time = Time.now

puts 'creating messages...'

conversations = Conversation.all

800.times do
  conversation = conversations.sample
  conversation.messages.create(
    :body => Faker::Hacker.say_something_smart,
    :sent => Faker::Time.between(1.month.ago, Time.now, :all),
    :sender => conversation.users.sample
  )
end

puts "created messages in #{Time.now - initial_time} seconds"