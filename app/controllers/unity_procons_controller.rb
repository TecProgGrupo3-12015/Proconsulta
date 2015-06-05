# encoding: UTF-8

# File: unity_procons_controller.rb
# Purpose of class: Contains action methods for unity procons view.
# This software follows GPL license.
# Proconsulta Group.
# FGA-UnB Faculdade de Engenharias do Gama - Universidade de Brasília.
class UnityProconsController < ApplicationController
	# Show all procon units
	def index
		@search = UnityProcon.search(params[:q])
		@unity_procons_search = @search.result
		@unity_procons = @unity_procons_search.paginate(page: params[:page])
	end

	# Show one especific procon unity associated with one especific id
	def show
	  @unity_procon = UnityProcon.find(params[:id])
	  @rating = Rating.new
	  @ratings = Rating.where("unity_procon_id = ?", params[:id]).order("created_at DESC")
	  @ratingpie = Rating.where("unity_procon_id = ?", params[:id])
	  @rating_hash = return_hash
	  @hash = Gmaps4rails.build_markers(@unity_procon) do |unity_procon, marker|
	  	marker.lat unity_procon.latitude
	 		marker.lng unity_procon.longitude
		end
		CUSTOM.LOGGER.info("Showed unity procon #{@unity_procon.to_yaml}")
	end

	# Return the rating from one especific procon unity 
	def return_hash
		hash = Hash.new
		all_rating = Rating.where("unity_procon_id = ?", params[:id])
		all_rating.each do |rating|
		case rating.value_rating
			when 1
				ratings = Rating.all.select { |m| m.value_rating == rating.value_rating }
				hash["Péssimo"] = ratings.count
				CUSTOM.LOGGER.info("Rated unity procon #{@unity_procon.to_yaml}")
			when 2
				ratings = Rating.all.select { |m| m.value_rating == rating.value_rating }	
				hash["Ruim"] = ratings.count
				CUSTOM.LOGGER.info("Rated unity procon #{@unity_procon.to_yaml}")
			when 3
				ratings = Rating.all.select { |m| m.value_rating == rating.value_rating }
				hash["Regular"] = ratings.count
				CUSTOM.LOGGER.info("Rated unity procon #{@unity_procon.to_yaml}")
			when 4
				ratings = Rating.all.select { |m| m.value_rating == rating.value_rating }
				hash["Bom"] = ratings.count
				CUSTOM.LOGGER.info("Rated unity procon #{@unity_procon.to_yaml}")
			when 5
				ratings = Rating.all.select { |m| m.value_rating == rating.value_rating }
				hash["Ótimo"] = ratings.count
				CUSTOM.LOGGER.info("Rated unity procon #{@unity_procon.to_yaml}")
			else
				CUSTOM.LOGGER.info("Failure to rate a unity procon")
			end	
		end
		hash
	end

	# Order the procon unitys
	def ranking
		@unity_procons = UnityProcon.order(:position_unity_procon)
	end

	def edit
		CUSTOM.LOGGER.info("Started to edit unity procon #{@unity_procon.to_yaml}")
	end

	# Search the procon unity by UF(Unidade da Federacao) and another param
	def custom_search
		unless request.xhr? || params[:page].nil? || params[:search].nil?
			redirect_to root_path
		end
		sql = "1=1"
		sql = sql
		# Data receives a search of unity procon
		data = UnityProcon.where("uf_procon = ?", params[:search]).paginate(:page=>1)
		render :json=>data.to_json
		CUSTOM.LOGGER.info("Searched a unity procon #{data.to_yaml}")
	end

	# Search the procon unity and order by ranking 
	def custom_search_ranking
		unless request.xhr? || params[:page].nil? || params[:search].nil?
			redirect_to root_path
			return
		end
		sql = "1=1"
		sql = sql
		# Sort in descending order unity procons' rating if a search parameter is # entered or not
		if params[:search] == ""
			data = UnityProcon.where("average_pontuation is not null").order('average_pontuation DESC').paginate(:page=>1)
			CUSTOM.LOGGER.info("Searched a unity procon without params ordered #{data.to_yaml}")
		else
			data = UnityProcon.where("uf_procon = ? and average_pontuation is not null", params[:search]).order('average_pontuation DESC').paginate(:page=>1)
			CUSTOM.LOGGER.info("Searched a unity procon ordered #{data.to_yaml}")
		end
		render :json=>data.to_json
	end

	# Uptade the procon unity's rating 
	def update
		@unity_procon = UnityProcon.find(params[:id])
 		@user = current_user
 		# Update unity procons' rating if this is possible
		if (@unity_procon.update_attributes(params[:unity_procon]))
			@rating = @unity_procon.ratings.last
			@rating.user_id = @user.id
			@rating.save
			@unity_procon.average_pontuation = Rating.where("unity_procon_id =?", @unity_procon.id).average(:value_rating)
			@unity_procon.save
			flash[:notice] = "Avaliação concluida"
			CUSTOM.LOGGER.info("Updated unity procon #{@unity_procon.to_yaml}")
		else
			flash[:notice] = "ERRO!"
			CUSTOM.LOGGER.error("Failure to update unity procon #{@unity_procon.to_yaml}")
		end
		redirect_to @unity_procon
	end
end
