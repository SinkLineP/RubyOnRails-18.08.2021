# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    describe '.find_for_auth' do
        let!(name :user) { create(:user) }
        let(:auth) { OmniAuth::AuthHash.new(create_params) }
        let(:create_params) {{ provider: 'facebook', uid: '123456' }}

        context "user already has auth" do
            it "returns the user" do 
                user.authorizations.create(create_params)
                expect(User.find_for_oauth(auth)).to eq user  
            end
        end      
    end
end
