namespace :create_admin do

  task build: :environment do
            puts "Creating Admin ...."

            admin = Admin.new({:first_name => "vijay", :last_name => "admin", :job => "admin",:location => "virginia",:mobile => "7878787878",
              :email => "admin@hicomm.co",:privacy => "private",:country => "USA", :type => "Admin", :is_active => true, 
              :password => "hicomm123", :password_confirmation => "hicomm123"}).save(:validate => false)
                   
            puts "Admin created Successfully.......................!"
 end
end









