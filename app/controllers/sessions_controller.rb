# File: sessions_controller.rb
# Purpose of class: Contains action methods for sessions view.
# This software follows GPL license.
# Proconsulta Group.
# FGA-UnB Faculdade de Engenharias do Gama - Universidade de Brasília.
class SessionsController < ApplicationController

	def new
	end

	#  Log in
	def create

		#Recivies User object by email adress and ignore uppercase letters
		user = User.find_by_email_user(params[:session][:email_user].downcase)

		user_is_authenticate = user && user.authenticate(params[:session][:password])
		
		if user_is_authenticate 
			sign_in user
			redirect_to user
			flash[:sucess] = "Logado com exito!"
		else
			flash.now[:error] = "Combinacao invalida de email e senha."
      render 'new'
		end
	end

	# Sign out
	def destroy
		flash[:sucess] = "Deslogado com exito."
		sign_out
		redirect_to root_url
	end
end
