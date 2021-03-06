require 'rspec/its'
require 'spec_helper'
require 'rails_helper'

describe Supplier do
	before do
		@supplier = FactoryGirl.create(:supplier)
	end

	subject { @supplier }
		it { should respond_to(:type_supplier) }
		it { should respond_to(:social_reason_supplier) }
		it { should respond_to(:fantasy_name_supplier) }
		it { should respond_to(:cnpj) }
		it { should respond_to(:cnaep_main_code_supplier) }
		it { should respond_to(:description_cnaep_code_supplier) }

	describe "supplier already taken" do
    #	before do
    #		supplier_with_same_name = @supplier.dup
    #		supplier_with_same_name.cnpj = @user.email_user.upcase
    #		supplier_with_same_name.save
    #	end

    #	it { should_not be_valid }
    end

end