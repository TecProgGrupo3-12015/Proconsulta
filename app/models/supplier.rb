# File: supplier.rb
# Purpose of class: Responsible for processing, validating, associate, other tasks in the treatment of suplier's data.
# This software follows GPL license.
# Proconsulta Group.
# FGA-UnB Faculdade de Engenharias do Gama - Universidade de Brasília.
class Supplier < ActiveRecord::Base
	has_many :customer_services
	attr_accessible :type_supplier, 
									:social_reason_supplier, 
									:fantasy_name_supplier, 
									:cnpj, 
									:cnaep_main_code_supplier, 
									:description_cnaep_code_supplier
end
