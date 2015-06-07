# File: users_controller.rb
# Purpose of class: Users actions controller
# This software follows GPL license.
# Proconsulta Group
# FGA-UnB Faculdade de Engenharias do Gama - Universidade de Brasília
class UsersController < ApplicationController

	# Returns all users
	def allusers
		@users = User.all
		CUSTOM_LOGGER.info("Start to return users #{@user.to_yaml}")
	end

	# Return to index all users
	def index
		@user = User.all
		CUSTOM_LOGGER.info("Start to return users #{@user.to_yaml}")
	end

	# Create new user
	def new
		@user = User.new
		CUSTOM_LOGGER.info("Start to create user #{@user.to_yaml}")
	end

	# Create and associate one user to one id.
	def create
		@user = User.new(user_params)
		# If user was save with succes, then sign in automaticly, else, render new.
		if @user.save
			sign_in @user
		 	flash[:sucess] = "Seja bem-vindo!"
			redirect_to :action => :show, :id => @user.id
			CUSTOM_LOGGER.info("Created and associated user to params #{@user.to_yaml}")
		else
			render 'new'
			CUSTOM_LOGGER.error("Not created and associated user to params #{@user.to_yaml}")
		end
	end

	# Show an especific user.
	def show
		# Find all users with id passed by params.
		@user = User.find(params[:id])
		CUSTOM_LOGGER.info("Start to find users #{@user.to_yaml}")
	end

	# Edit an user.
	def edit
		@user = User.find(params[:id])
		# Valid if the user not is logged, is true, redirect to home.
		if !signed_in? || current_user != @user
			redirect_to root_path
			flash[:danger] = "Essa conta nao é sua!"
			CUSTOM_LOGGER.error("There is no user session created #{@user.to_yaml}")
		else
			# nothing to do.
			CUSTOM_LOGGER.warn("Nothing to do!")

		end
	end

	# Update one edited user.
	def update
		@user = User.find(params[:id])
		@update_attributes = @user.update_attributes(user_params)
		# Verify if the user has his attributes update, if true: show alert,
		# signin and redirect to @user.
		# Else, go to edit view.
		if @update_attributes
			flash[:sucess] = "Usuário editado com exito!"
			sign_in(@user)
			redirect_to @user
			CUSTOM_LOGGER.info("User edited successfully #{@user.to_yaml}")
		else
			render 'edit'
			CUSTOM_LOGGER.error("User not updated and not found #{@user.to_yaml}")
		end
	end

	# delete an user.
	def destroy
		@user = User.find(params[:id])
		@destroy = @user.destroy
		# If the logged current user different of instance @user, then redirect
		# home and show alert message.
		# Else destroy the instance user, redirect to home and show succes message.
		if current_user == @user
			@destroy
			redirect_to root_path
			flash[:sucess] = "Usuário excluido com exito."
			CUSTOM_LOGGER.info("User destroy successfully #{@user.to_yaml}")
		else
			redirect_to root_path
			flash[:error] = "Essa conta nao é sua!"
			CUSTOM_LOGGER.error("Failure to destroy user #{@user.to_yaml}")
		end
	end

  private
	def user_params
	params.require(:user).permit(:name_user, 
															 :email_user,
															 :address_user, 
															 :password_confirmation,
															 :password)
	CUSTOM_LOGGER.info("User params confirmation")
	end
end
