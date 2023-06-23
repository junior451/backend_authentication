require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "authentication" do
    it "should authenticate and response with a token when user logins" do
      user = create(:user)
      
      allow(JsonWebToken).to receive(:encode).with(user_id: user.id).and_return("eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2ODY3MzU4ODN9.agcfsG-BYQgvMgX12dVBEmAf_6Vneuq5qD_3oSle3_0")

      post "/login", params: { username: user.username, password: "my_password" }

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(json[:token]).to eq("eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2ODY3MzU4ODN9.agcfsG-BYQgvMgX12dVBEmAf_6Vneuq5qD_3oSle3_0")

      expect(response.status).to eq 200
    end
  end
end
