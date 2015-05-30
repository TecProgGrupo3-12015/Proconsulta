# File: unity_procon.rb
# Purpose of class: Responsible for processing, validating, associate, other
# tasks in the treatment of unity procon's data.
# This software follows GPL license.
# Proconsulta Group.
# FGA-UnB Faculdade de Engenharias do Gama - Universidade de Brasília.
class UnityProcon < ActiveRecord::Base
	geocoded_by :address_unity_procon
	after_validation :geocode
	has_many :ratings
	accepts_nested_attributes_for :ratings
	# Creating atributs to model unity_procon
	attr_accessible :address_unity_procon, 
	                :name_coordinator_unity_procon,
	                :uf_procon, 
	                :email_unity_procon, 
	                :list_phones, 
	                :position_unity_procon, 
	                :ratings_attributes, 
	                :average_pontuation, 
	                :latitude, 
	                :longitude
end
