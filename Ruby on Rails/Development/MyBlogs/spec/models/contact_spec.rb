require 'rails_helper'


	RSpec.describe Contact, :type => :model do
		describe Contact do
		  it { should validate_presence_of :email }
		  it { should validate_presence_of :message }
	  end	
	end