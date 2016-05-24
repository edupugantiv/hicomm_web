class PasswordsController < ApplicationController
  before_filter :authenticate_user!

  def change_password
    old_password = params[:user][:current_password]
    new_password = params[:user][:password]
    confirm_password = params[:user][:password_confirmation]

    if (old_password == '' || new_password == '' || confirm_password == '')
      redirect_to :back,:alert => 'Please fill all the fields'
    else
      if new_password.strip.length > 7 && new_password.strip.length < 72
        if current_user.valid_password?(old_password)
          if new_password == confirm_password
            @user = current_user
            current_user.update(password: new_password)
            sign_in @user, :bypass => true
            redirect_to :home, :notice => 'Password updated successfully'
          else
            redirect_to :back, :alert => 'New and confirm password did not match'
          end
        else
          redirect_to :back, :alert => 'Incorrect Old Password'
        end
      else
        redirect_to :back, :alert => 'Password should be atleast 8 charecters'
      end
    end
  end
end