# File: suppliers_controller.rb
# Purpose of class: Contains action methods for supliers view
# This software follows GPL license
# Proconsulta Group
# FGA-UnB Faculdade de Engenharias do Gama - Universidade de Brasília


class SuppliersController < ApplicationController
	# Show 	all sppliers
	def index
		@search = Supplier.search(params[:q])
		@suppliers_search = @search.result
		@suppliers = @suppliers_search.paginate(page: params[:page])
	end

	# Show supplier associated with one especific id
	def show
		@supplier = Supplier.find(params[:id])
    @hash = hash_format_graph
	end

	# Format the graph of suppliers
	def hash_format_graph
		quantity_total = @supplier.customer_services.count
		hash = @supplier.customer_services.order('count_all desc').limit(10).group(:description_problem_customer_service).count
		array_quantity =  hash.map { |key, value| value }
		quantity = array_quantity.inject(:+)
		
		unless quantity_total.nil?
      unless quantity.nil?
      	outros = (quantity_total - quantity)
      	another_hash = {"outros" => outros }
      	hash = hash.merge(another_hash)
      end
    end 
	end
end
