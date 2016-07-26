class UsersController < ApplicationController
	before_action :authenticate_user!, except: [:forgot_password, :forgot_password_send_otp, :forgot_password_process_otp, :forgot_password_enter_otp, :mass_signup, :mass_create]
	before_filter :verify_current_user, only: [:edit, :update, :manage, :delete_account, :delete_user]
	
	def show
		@user = User.includes(:projects, :groups, :colleagues).friendly.find(params[:id])
		if current_user.slug == params[:id]
			@projects = @user.projects
			@groups = @user.groups
			@contacts = @user.colleagues
		else
			@projects = @user.projects - Project.where(:privacy => "private")
			@groups = @user.groups - Group.where(:privacy => "private")
			@contacts = @user.colleagues - User.where(:privacy => "private")
		end
	end

	def new
		@user = User.new(sign_up_params)
	end

	def create
		@user = User.create(user_params)
	end

	def edit
		@user = User.friendly.find(params[:id])
		@user.save
	end

	def update
		@user = User.friendly.find(params[:id])
		@user.update_attributes(user_params)
		redirect_to manage_user_path(@user), notice: "Your account was successfully updated"
	end

	def manage
		@user = User.friendly.find(params[:id])
	end

	def add_colleague
		@user = current_user
		@colleague = User.friendly.find(params[:id])
		@user.colleagues << @colleague
		@colleague.colleagues << @user
		redirect_to :back, notice: "#{@colleague.name} has been added to your contacts"
	end

	def remove_colleague
		@user = current_user
		@colleague = User.friendly.find(params[:id])
		@user.colleagues.delete(@colleague)
		@colleague.colleagues.delete(@user)
		redirect_to :back, notice: "#{@colleague.name} has been removed from your contacts"
	end

	def delete_account
		@user = current_user
	end

	def delete_user
		@user = current_user
		@user.update(is_active: false)
    sign_out current_user
    redirect_to new_user_session_path
	end

	def mass_signup
	end

	def mass_create
		number_of_users = params[:mass_user_count].to_i
		begin
			(1..number_of_users).each do |index|
				if params["password_#{index}"] == params["confirm_password_#{index}"]
					User.create(first_name: params["first_name_#{index}"], mobile: params["mobile_#{index}"], password: params["password_#{index}"], 
						password_confirmation: params["confirm_password_#{index}"])
				else
					redirect_to :back, notice:  "#{index} indexed user's password and confirm password doesn't match." and return
				end
			end

			redirect_to :back, notice:  "#{number_of_users} users successfully added."
    rescue Exception => e
    	if e.to_s.include? 'Duplicate entry'
      	redirect_to :back, notice: "The mobile number #{e.to_s[32..41]} is already registered with us. Please try again after removing the number from the list."
    	else
      	redirect_to :back, notice: 'There was some error while adding users, please try again after verifying values.'
    	end
    end
	end

	def forgot_password
		
	end

	def forgot_password_send_otp
		mobile = params[:mobile]
		otp = rand(1000..9999)
		user = User.find_by(mobile: mobile)
		if user.nil?
			redirect_to :back, notice: 'Entered mobile number is not registered with us.'
		else
			user.update(otp: otp)
			user.send_forgot_password_message
			redirect_to forgot_password_enter_otp_users_path(mobile)
		end
	end

	def forgot_password_enter_otp
		mobile = params[:mobile]
		user = User.find_by(mobile: mobile)
		if user.nil?
			redirect_to forgot_password_users_path, notice: 'Entered mobile number is not registered with us.'
		else
			@mobile = user.mobile
		end
	end

	def forgot_password_process_otp
		mobile = params[:mobile]
    new_password = params[:new_password]
  	confirm_password = params[:confirm_password]
  	otp = params[:otp].to_i

		user = User.find_by(mobile: mobile)
		if user.nil?
			redirect_to forgot_password_users_path, notice: 'Entered mobile number is not registered with us.'
		elsif user.otp != otp
			redirect_to :back, notice: 'Entered otp is invalid.'
		else
	    if (new_password == '' || confirm_password == '')
      	redirect_to :back,:alert => 'Please fill all the fields'
    	else
	      if new_password.strip.length > 7 && new_password.strip.length < 72
          if new_password == confirm_password
            user.update(password: new_password, otp: 0000)
            sign_in user, :bypass => true
            redirect_to :home, :notice => 'Password updated successfully'
          else
            redirect_to :back, :alert => 'New and confirm password did not match'
          end
	      else
	        redirect_to :back, :alert => 'Password should be atleast 8 charecters'
	      end
	    end
		end
	end

	private
	def user_params
		if current_user.is_admin?
			params.require(:admin).permit(:first_name, :last_name, :job, :location, :mobile, :email, :privacy, :avatar)
		else
			params.require(:user).permit(:first_name, :last_name, :job, :location, :mobile, :email, :privacy, :avatar)
		end
	end

	def account_update_params
		params.require(:user).permit(:first_name, :last_name, :location, :job, :mobile, :email, :password, :password_confirmation, :current_password, :privacy)
	end

	def verify_current_user
		@user = User.friendly.find(params[:id])
		if current_user.slug != params[:id]
			redirect_to errors_not_found_path
		end
	end
end